# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/games/:game_name/current_player' do
  let(:game) { create(:game) }

  describe 'GET /show' do
    subject :show_current_player do
      get api_game_current_player_url(game_name: game.name),
          headers: {
            Authorization: authorization_header
          },
          as: :json
    end

    context 'when valid access_token' do
      let(:player) { create(:player, game:) }
      let(:authorization_header) { "Bearer #{player.generate_token}" }

      it do
        show_current_player
        expect(response).to have_http_status(:ok)
        expect(response_json[:status]).to eq 'success'
        expect(response_json.dig(:data, :current_player, :id)).to eq player.id
      end
    end
  end

  describe 'POST /create' do
    subject :create_current_player do
      post api_game_current_player_url(
        game_name: game.name,
        current_player:
      ), as: :json
    end

    context 'when valid name' do
      let(:current_player) do
        {
          name: 'Rutan'
        }
      end

      it do
        create_current_player
        expect(response).to have_http_status(:created)
        expect(response_json[:status]).to eq 'success'
        expect(response_json.dig(:data, :current_player, :name)).to eq current_player[:name]
        expect(response_json.dig(:data, :token)).to be_truthy
      end
    end
  end

  describe 'PUT /create' do
    subject :update_current_player do
      put api_game_current_player_url(
        game_name: game.name,
        current_player:
      ),
          headers: {
            Authorization: authorization_header
          },
          as: :json
    end

    context 'when valid parameters' do
      let(:player) { create(:player, game:) }
      let(:authorization_header) { "Bearer #{player.generate_token}" }
      let(:current_player) do
        {
          name: 'Rutan',
          shared_data: '良いデータ'
        }
      end

      it do
        update_current_player
        expect(response).to have_http_status(:ok)
        expect(response_json[:status]).to eq 'success'
        expect(response_json.dig(:data, :current_player, :name)).to eq current_player[:name]
        expect(response_json.dig(:data, :current_player, :shared_data)).to eq current_player[:shared_data]
      end
    end
  end
end
