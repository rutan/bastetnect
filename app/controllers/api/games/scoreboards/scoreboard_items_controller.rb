# frozen_string_literal: true

module Api
  module Games
    module Scoreboards
      class ScoreboardItemsController < ApplicationController
        before_action :require_login!, only: [:create]

        # GET /games/:game_name/scoreboards/:scoreboard_index/scoreboard_items
        def index
          @start_index = param_page * param_limit
          @scoreboard_items =
            scoreboard.scoreboard_items
                      .joins(:player)
                      .merge(Player.visible_for_list(current_player))
                      .order_with_rank(scoreboard)
                      .page(param_page)
                      .per(param_limit)
        end

        # POST /games/:game_name/scoreboards/:scoreboard_index/scoreboard_items
        def create
          new_score = item_params[:score].to_i

          @scoreboard_item = ScoreboardItem.find_or_initialize_by(
            scoreboard:,
            player: current_player
          )
          @scoreboard_item.update_score!(new_score)

          @current_score = new_score
          @current_rank = scoreboard.guess_rank(new_score)

          render status: :created
        end

        private

        def item_params
          params.expect(scoreboard_item: [:score])
        end
      end
    end
  end
end
