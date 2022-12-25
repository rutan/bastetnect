# frozen_string_literal: true

module Api
  module Games
    module Scoreboards
      class ApplicationController < ::Api::Games::ApplicationController
        private

        def scoreboard
          Scoreboard.find_by!(game:, index: params[:scoreboard_index])
        end
      end
    end
  end
end
