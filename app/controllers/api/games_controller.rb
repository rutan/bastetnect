# frozen_string_literal: true

module Api
  class GamesController < ApplicationController
    # GET /api/games
    def index
      @games = Game.public_visible.page(param_page).per(param_limit)
    end

    # GET /api/games/:name
    def show
      @game = Game.visible.find_by!(name: params[:name])
    end
  end
end
