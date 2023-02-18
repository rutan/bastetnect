# frozen_string_literal: true

module Api
  module Games
    class ScoreboardsController < ApplicationController
      # GET /games/:game_name/scoreboards/:index
      def show
        @scoreboard = scoreboard
      end

      private

      def scoreboard
        index = params.permit(:index)[:index]
        Scoreboard.find_by!(game:, index:)
      end
    end
  end
end
