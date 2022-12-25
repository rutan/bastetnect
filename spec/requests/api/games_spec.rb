# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/games' do
  describe 'GET /index' do
    subject do
      get api_games_url, as: :json
    end

    before do
      create(:game, status: :active)
      create(:game, status: :hidden)
      create(:game, status: :frozen)
      create(:game, status: :dead)
    end

    it do
      subject
      expect(response).to be_successful
      expect(response_json[:status]).to eq 'success'
      expect(response_json.dig(:data, :games).size).to eq 2
    end
  end

  describe 'GET /show' do
    subject do
      get api_game_url(name: game_name), as: :json
    end

    context 'when active game' do
      let(:game) { create(:game, status: :active) }
      let(:game_name) { game.name }

      it do
        subject
        expect(response).to be_successful

        expect(response_json[:status]).to eq 'success'
        expect(response_json.dig(:data, :game, :name)).to eq game.name
        expect(response_json.dig(:data, :game, :play_count)).to eq game.play_count
      end
    end

    context 'when hidden game' do
      let(:game) { create(:game, status: :hidden) }
      let(:game_name) { game.name }

      it do
        subject
        expect(response).to be_successful

        expect(response_json[:status]).to eq 'success'
        expect(response_json.dig(:data, :game, :name)).to eq game.name
        expect(response_json.dig(:data, :game, :play_count)).to eq game.play_count
      end
    end

    context 'when frozen game' do
      let(:game) { create(:game, status: :frozen) }
      let(:game_name) { game.name }

      it do
        subject
        expect(response).to be_successful

        expect(response_json[:status]).to eq 'success'
        expect(response_json.dig(:data, :game, :name)).to eq game.name
        expect(response_json.dig(:data, :game, :play_count)).to eq game.play_count
      end
    end

    context 'when dead game' do
      let(:game) { create(:game, status: :dead) }
      let(:game_name) { game.name }

      it do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when not found game' do
      let(:game_name) { 'not-found-game' }

      it do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
