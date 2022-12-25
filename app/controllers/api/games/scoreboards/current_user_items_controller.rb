# frozen_string_literal: true

module Api
  module Games
    module Scoreboards
      class CurrentUserItemsController < ApplicationController
        before_action :require_login!

        # GET /games/:game_name/scoreboards/:scoreboard_index/current_user_item
        def show
          @scoreboard_item = ScoreboardItem.find_by!(
            scoreboard:,
            player: current_player
          )
          @scoreboard_item_rank = scoreboard.guess_rank(@scoreboard_item.score)

          render :show
        end
      end
    end
  end
end
