# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/games/:game_name/active_player_count' do
  let(:game) { create(:game) }

  describe 'GET /show' do
    subject do
      get api_game_active_player_count_url(game_name: game.name, minutes: 10),
          as: :json
    end

    before do
      create(:player, game:, last_play_at: 11.minutes.ago)
      create(:player, game:, last_play_at: 9.minutes.ago)
      create(:player, game:, last_play_at: 5.minutes.ago)
      create(:player, game:, last_play_at: 1.minute.ago)
    end

    it do
      subject
      expect(response).to have_http_status(:ok)
      expect(response_json[:status]).to eq 'success'
      expect(response_json.dig(:data, :active_player_count)).to eq 3
    end
  end
end
