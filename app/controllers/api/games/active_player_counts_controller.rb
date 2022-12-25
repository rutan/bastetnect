# frozen_string_literal: true

module Api
  module Games
    class ActivePlayerCountsController < ApplicationController
      # GET /api/games/:game_name/active_player_counts
      def show
        time = param_minutes.minutes.ago
        @active_player_count = game.players.where(last_play_at: time...).count
      end

      private

      def param_minutes
        (params[:minutes] || 5).to_i.tap do |minutes|
          raise InvalidParameterError, :minutes unless minutes.between?(1, 60)
        end
      end
    end
  end
end
