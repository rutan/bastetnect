# frozen_string_literal: true

module Api
  module Games
    class GameSignalsController < ApplicationController
      before_action :require_login!, only: [:create]

      # GET /api/games/:game_name/game_signals
      def index
        @game_signals = game.game_signals
                            .joins(:sender)
                            .merge(Player.visible_for_list(current_player))
                            .page(1)
                            .per(param_limit(max: 2000, default_value: 250))
      end

      # POST /api/games/:game_name/game_signals
      def create
        @game_signal = GameSignal.create!(
          game:,
          sender: current_player,
          data: game_signal_params[:data] || ''
        )

        render :show, status: :created
      end

      private

      def game_signal_params
        params.permit(:data)
      end
    end
  end
end
