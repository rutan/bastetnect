# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/games/:game_name/players' do
  let(:game) { create(:game) }

  describe 'GET /index' do
    subject :index_players do
      get api_game_players_url(game_name: game.name), as: :json
    end

    let!(:players) { create_list(:player, 10, game:) }

    it do
      index_players
      expect(response).to have_http_status(:ok)
      expect(response_json[:status]).to eq 'success'
      expect(response_json.dig(:data, :players).size).to eq 10
      expect(response_json.dig(:data, :players)[0][:name]).to eq players.first.name
    end
  end

  describe 'GET /show' do
    subject :show_player do
      get api_game_player_url(game_name: game.name, id: player_id), as: :json
    end

    let(:player) { create(:player, game:) }
    let(:player_id) { player.id }

    it do
      show_player
      expect(response).to have_http_status(:ok)
      expect(response_json[:status]).to eq 'success'
      expect(response_json.dig(:data, :player, :name)).to eq player.name
    end
  end
end
