# frozen_string_literal: true

# == Route Map
#

Rails.application.routes.draw do
  root 'root#show', defaults: { format: :json }

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
      end
    end
  end
end
