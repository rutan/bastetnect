# frozen_string_literal: true

module Api
  module Games
    class CurrentPlayersController < ApplicationController
      before_action :require_login!, except: [:create]

      # GET /api/games/:game_name/current_player
      def show
        @current_player = current_player
      end

      # POST /api/games/:game_name/current_player
      def create
        @current_player = Player.create!(
          current_player_params.merge(game:)
        )
        @token = GameAuthorizer.new(game, @current_player).generate_token

        render status: :created
      end

      # PUT /api/games/:game_name/current_player
      def update
        @current_player = current_player
        current_player.update(current_player_params)

        render :show
      end

      private

      def current_player_params
        params.required(:current_player).permit(:name, :shared_data)
      end
    end
  end
end