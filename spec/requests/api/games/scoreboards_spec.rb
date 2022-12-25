# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/games/:game_name/scoreboard' do
  let(:game) { create(:game) }

  describe 'GET /show' do
    subject :show_scoreboard do
      get api_game_scoreboard_url(game_name: game.name, index: scoreboard_index), as: :json
    end

    context 'when valid index' do
      let(:scoreboard) { create(:scoreboard, game:) }
      let(:scoreboard_index) { scoreboard.index }

      it do
        show_scoreboard
        expect(response).to have_http_status(:ok)
        expect(response_json[:status]).to eq 'success'
        expect(response_json.dig(:data, :scoreboard, :name)).to eq scoreboard.name
      end
    end

    context 'when invalid index' do
      let(:scoreboard_index) { 99_999 }

      it do
        show_scoreboard
        expect(response).to have_http_status(:not_found)
        expect(response_json[:status]).to eq 'error'
      end
    end
  end
end
