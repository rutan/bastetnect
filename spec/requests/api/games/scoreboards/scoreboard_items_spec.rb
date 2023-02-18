# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/games/:game_name/scoreboards/:scoreboard_index/scoreboard_items' do
  let(:game) { create(:game) }

  describe 'GET /index' do
    subject do
      get api_game_scoreboard_scoreboard_items_url(game_name: game.name, scoreboard_index:),
          as: :json
    end

    context 'when exist scoreboard' do
      let(:scoreboard) { create(:scoreboard, game:) }
      let(:scoreboard_index) { scoreboard.index }
      let!(:scoreboard_items) { create_list(:scoreboard_item, 10, scoreboard:) }

      it do
        subject
        expect(response).to have_http_status(:ok)
        expect(response_json[:status]).to eq 'success'
        expect(response_json.dig(:data, :scoreboard_items).size).to eq scoreboard_items.size
      end
    end
  end

  describe 'POST /create' do
    subject do
      post api_game_scoreboard_scoreboard_items_url(game_name: game.name, scoreboard_index: scoreboard.index),
           params:,
           headers: {
             Authorization: authorization_header,
             'X-Requested-With': 'rspec'
           },
           as: :json
    end

    let(:scoreboard) { create(:scoreboard, game:) }

    context 'when valid token' do
      let(:player) { create(:player, game:) }
      let(:authorization_header) { "Bearer #{player.generate_token}" }

      context 'when valid param' do
        let(:score) { 12_345 }
        let :params do
          {
            scoreboard_item: { score: }
          }
        end

        context 'when first record' do
          it do
            expect { subject }.to change(ScoreboardItem, :count).by(1)
            expect(response).to have_http_status(:created)
            expect(response_json[:status]).to eq 'success'
            expect(response_json.dig(:data, :scoreboard_item, :score)).to eq params[:scoreboard_item][:score]
          end
        end

        context 'when second record' do
          before do
            create(:scoreboard_item, scoreboard:, player:, score: 1000)
          end

          context 'when new record' do
            it do
              expect { subject }.not_to change(ScoreboardItem, :count)
              expect(response).to have_http_status(:created)
              expect(response_json[:status]).to eq 'success'
              expect(response_json.dig(:data, :scoreboard_item, :score)).to eq params[:scoreboard_item][:score]
            end
          end

          context 'when not new record' do
            let(:score) { 500 }

            it do
              expect { subject }.not_to change(ScoreboardItem, :count)
              expect(response).to have_http_status(:created)
              expect(response_json[:status]).to eq 'success'
              expect(response_json.dig(:data, :scoreboard_item, :score)).to eq 1000
              expect(response_json.dig(:data, :current_item, :score)).to eq params[:scoreboard_item][:score]
            end
          end
        end
      end
    end
  end
end
