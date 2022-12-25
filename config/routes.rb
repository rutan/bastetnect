# frozen_string_literal: true

Rails.application.routes.draw do
  # /api
  namespace :api, defaults: { format: :json } do
    # /api/games
    resources :games, param: :name, only: [:index, :show] do
      scope module: :games do
        # /api/games/:game_name/active_player_count
        resource :active_player_count, only: [:show]

        # /api/games/:game_name/game_signals
        resources :game_signals, only: [:index, :create]

        # /api/games/:game_name/current_player
        resource :current_player, only: [:show, :create, :update] do
          scope module: :current_players do
            # /api/games/:game_name/current_player/player_signals
            resources :player_signals, only: [:index]
          end
        end

        # /api/games/:game_name/players
        resources :players, only: [:index, :show] do
          scope module: :players do
            # /api/games/:game_name/players/:player_id/player_signals
            resources :player_signals, only: [:create]
          end
        end

        # /api/games/:game_name/scoreboards
        resources :scoreboards, param: :index, only: [:show] do
          scope module: :scoreboards do
            # /api/games/:game_name/scoreboards/:scoreboard_index/scoreboard_items
            resources :scoreboard_items, only: [:index, :create]

            # /api/games/:game_name/scoreboards/:scoreboard_index/current_user_item
            resource :current_user_item, only: [:show]
          end
        end
      end
    end
  end
end
