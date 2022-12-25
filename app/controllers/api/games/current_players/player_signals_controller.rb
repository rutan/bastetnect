# frozen_string_literal: true

module Api
  module Games
    module CurrentPlayers
      class PlayerSignalsController < ApplicationController
        before_action :require_login!

        def index
          @player_signals =
            current_player.player_signals
                          .joins(:sender)
                          .merge(Player.visible_for_list(current_player))
                          .recent_received
                          .page(param_page(100))
                          .per(param_limit(max: 1000, default_value: 100))
        end
      end
    end
  end
end
