# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/games/:game_name/scoreboards/:scoreboard_index/current_user_items' do
  let(:game) { create(:game) }
  let(:scoreboard) { create(:scoreboard, game:) }

  describe 'GET /show' do
    subject do
      get api_game_scoreboard_current_user_item_url(game_name: game.name, scoreboard_index: scoreboard.index),
          headers: {
            Authorization: authorization_header,
            'X-Requested-With': 'rspec'
          },
          as: :json
    end

    context 'when valid token' do
      let(:player) { create(:player, game:) }
      let(:authorization_header) { "Bearer #{player.generate_token}" }

      context 'when has record' do
        let!(:scoreboard_item) { create(:scoreboard_item, scoreboard:, player:, score: 1000) }

        it do
          subject
          expect(response).to have_http_status(:ok)
          expect(response_json[:status]).to eq 'success'
          expect(response_json.dig(:data, :scoreboard_item, :score)).to eq scoreboard_item.score
        end
      end

      context 'when no record' do
        it do
          subject
          expect(response).to have_http_status(:not_found)
          expect(response_json[:status]).to eq 'error'
        end
      end
    end
  end
end
