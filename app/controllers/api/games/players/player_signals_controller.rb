# frozen_string_literal: true

module Api
  module Games
    module Players
      class PlayerSignalsController < ApplicationController
        before_action :require_login!, only: [:create]

        def create
          @player_signal =
            PlayerSignal.create!(
              player_signal_params.merge(
                player: target_player,
                sender: current_player
              )
            )

          render status: :created
        end

        private

        def target_player
          Player.visible_for_show.find_by!(game:, id: params[:player_id])
        end

        def player_signal_params
          params.required(:player_signal).permit(:data)
        end
      end
    end
  end
end
