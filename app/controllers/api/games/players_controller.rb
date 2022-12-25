# frozen_string_literal: true

module Api
  module Games
    class PlayersController < ApplicationController
      # GET /api/games/:game_name/players
      def index
        @players =
          game_players
          .visible_for_list(current_player)
          .recent_access
          .page(param_page)
          .per(param_limit)
      end

      # GET /api/games/:game_name/players/:id
      def show
        @player = game_players.visible_for_show.find(params[:id])
      end

      private

      def game_players
        Player.where(game:)
      end
    end
  end
end
