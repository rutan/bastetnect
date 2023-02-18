# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/games/:game_name/current_player/player_signals' do
  let(:game) { create(:game) }

  describe 'GET /index' do
    subject do
      get api_game_current_player_player_signals_url(game_name: game.name),
          headers: {
            Authorization: authorization_header
          },
          as: :json
    end

    context 'when valid token' do
      let(:player) { create(:player, game:) }
      let(:authorization_header) { "Bearer #{player.generate_token}" }

      let!(:player_signals) { create_list(:player_signal, 10, player:) }

      it do
        subject
        expect(response).to have_http_status(:ok)
        expect(response_json[:status]).to eq 'success'
        expect(response_json.dig(:data, :player_signals).size).to eq 10
        expect(response_json.dig(:data, :player_signals)[0][:id]).to eq player_signals.last.id
      end
    end

    context 'when invalid token' do
      let(:authorization_header) { 'Bearer invalid' }

      it do
        subject
        expect(response).to have_http_status(:unauthorized)
        expect(response_json[:status]).to eq 'fail'
      end
    end
  end
end
