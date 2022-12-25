# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/games/:game_name/players/:player_id/player_signals' do
  let(:game) { create(:game) }

  describe 'POST /create' do
    subject :post_player_signals do
      post api_game_player_player_signals_url(game_name: game.name, player_id:),
           params:,
           headers: {
             Authorization: authorization_header
           },
           as: :json
    end

    let(:valid_param) do
      {
        player_signal: {
          data: 'ok'
        }
      }
    end

    let(:invalid_param) do
      {
        player_signal: {}
      }
    end

    context 'when valid target' do
      let(:target_player) { create(:player, game:) }
      let(:player_id) { target_player.id }

      context 'when valid token' do
        let(:player) { create(:player, game:) }
        let(:authorization_header) { "Bearer #{player.generate_token}" }

        context 'when valid params' do
          let(:params) { valid_param }

          it do
            post_player_signals
            expect(response).to have_http_status(:created)
            expect(response_json[:status]).to eq 'success'
            expect(response_json.dig(:data, :player_signal, :data)).to eq 'ok'
          end
        end

        context 'when invalid params' do
          let(:params) { invalid_param }

          it do
            post_player_signals
            expect(response).to have_http_status(:bad_request)
            expect(response_json[:status]).to eq 'fail'
          end
        end
      end

      context 'when invalid token' do
        let(:authorization_header) { 'Bearer invalid' }
        let(:params) { valid_param }

        it do
          post_player_signals
          expect(response).to have_http_status(:unauthorized)
          expect(response_json[:status]).to eq 'fail'
        end
      end
    end

    context 'when invalid target' do
      let(:player_id) { 9_999_999_999 }
      let(:authorization_header) { "Bearer #{create(:player, game:).generate_token}" }
      let(:params) { valid_param }

      it do
        post_player_signals
        expect(response).to have_http_status(:not_found)
        expect(response_json[:status]).to eq 'error'
      end
    end
  end
end
