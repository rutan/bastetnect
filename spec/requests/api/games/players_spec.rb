# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/games/:game_name/players' do
  let(:game) { create(:game) }

  describe 'GET /index' do
    subject do
      get api_game_players_url(game_name: game.name, with_shared_save:), as: :json
    end

    let!(:players) { create_list(:player, 10, game:) }

    context 'when no option parameter' do
      let(:with_shared_save) { nil }

      it do
        subject
        expect(response).to have_http_status(:ok)
        expect(response_json[:status]).to eq 'success'
        expect(response_json.dig(:data, :players).size).to eq 10
        expect(response_json.dig(:data, :players).first[:name]).to eq players.first.name
        expect(response_json.dig(:data, :players).first[:shared_save]).to be_nil
      end
    end

    context 'when with_shared_save parameter' do
      let(:with_shared_save) { 1 }

      it do
        subject
        expect(response).to have_http_status(:ok)
        expect(response_json[:status]).to eq 'success'
        expect(response_json.dig(:data, :players).size).to eq 10
        expect(response_json.dig(:data, :players).first[:name]).to eq players.first.name
        expect(response_json.dig(:data, :players).first.dig(:shared_save, :data)).to eq players.first.shared_save.data
      end
    end
  end

  describe 'GET /show' do
    subject do
      get api_game_player_url(game_name: game.name, id: player_id, with_shared_save:), as: :json
    end

    context 'when single id access' do
      let(:player) { create(:player, game:, shared_save: build(:shared_save)) }
      let(:player_id) { player.id }

      context 'when no option parameter' do
        let(:with_shared_save) { nil }

        it do
          subject
          expect(response).to have_http_status(:ok)
          expect(response_json[:status]).to eq 'success'
          expect(response_json.dig(:data, :player, :name)).to eq player.name
          expect(response_json.dig(:data, :player, :shared_save)).to be_nil
        end
      end

      context 'when with_shared_save parameter' do
        let(:with_shared_save) { 1 }

        it do
          subject
          expect(response).to have_http_status(:ok)
          expect(response_json[:status]).to eq 'success'
          expect(response_json.dig(:data, :player, :name)).to eq player.name
          expect(response_json.dig(:data, :player, :shared_save, :data)).to eq player.shared_save.data
        end
      end
    end

    context 'when multiple ids access' do
      let(:players) { create_list(:player, 10, game:, shared_save: build(:shared_save)) }
      let(:player_id) { players.map(&:id).join(',') }
      let(:with_shared_save) { nil }

      it do
        subject
        expect(response).to have_http_status(:ok)
        expect(response_json[:status]).to eq 'success'
        expect(response_json.dig(:data, :players).size).to eq players.size
      end
    end
  end
end
