# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/games/:game_name/game_signals' do
  describe 'GET /index' do
    subject :index_game_signals do
      get api_game_game_signals_url(game_name: game.name), as: :json
    end

    let(:game) { create(:game) }

    before do
      create_list(:game_signal, 10, game:)
    end

    it do
      index_game_signals
      expect(response).to have_http_status(:ok)
      expect(response_json[:status]).to eq 'success'
      expect(response_json.dig(:data, :game_signals).size).to eq 10
    end
  end

  describe 'POST /create' do
    subject :create_game_signals do
      post api_game_game_signals_url(
        game_name: game.name,
        data:
      ),
           headers: {
             Authorization: authorization_header
           },
           as: :json
    end

    let(:game) { create(:game) }

    context 'when valid access_token' do
      let(:player) { create(:player, game:) }
      let(:authorization_header) { "Bearer #{player.generate_token}" }

      context 'when valid data' do
        let(:data) { '1' }

        it do
          create_game_signals
          expect(response).to have_http_status(:created)
          expect(response_json[:status]).to eq 'success'
        end
      end

      context 'when invalid data' do
        let(:data) { '1' * 1000 }

        it do
          create_game_signals
          expect(response).to have_http_status(:bad_request)
          expect(response_json[:status]).to eq 'fail'
        end
      end
    end

    context 'when invalid access_token' do
      let(:authorization_header) { 'Bearer invalid_token_desuyo' }
      let(:data) { '1' }

      it do
        create_game_signals
        expect(response).to have_http_status(:unauthorized)
        expect(response_json[:status]).to eq 'fail'
      end
    end

    context 'when guest' do
      let(:authorization_header) { nil }
      let(:data) { '' }

      it do
        create_game_signals
        expect(response).to have_http_status(:unauthorized)
        expect(response_json[:status]).to eq 'fail'
      end
    end
  end
end
