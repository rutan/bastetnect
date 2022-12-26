# frozen_string_literal: true

module Api
  module Games
    class PlayersController < ApplicationController
      before_action :set_with_shared_save

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
        ids = parse_ids(:id)
        if ids.size > 1
          @players = game_players.visible_for_show.where(id: ids).page(1)

          render :index
        else
          @player = game_players.visible_for_show.find(params[:id])
        end
      end

      private

      def game_players
        Player.where(game:)
      end

      def set_with_shared_save
        @with_shared_save = params[:with_shared_save].to_i != 0
      end
    end
  end
end
