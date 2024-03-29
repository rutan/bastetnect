# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/api/games/:game_name/current_player' do
  let(:game) { create(:game) }

  describe 'GET /show' do
    subject do
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
        subject
        expect(response).to have_http_status(:ok)
        expect(response_json[:status]).to eq 'success'
        expect(response_json.dig(:data, :current_player, :id)).to eq player.id
      end
    end
  end

  describe 'POST /create' do
    subject do
      post api_game_current_player_url(
        game_name: game.name,
        current_player:
      ),
           headers: {
             'X-Requested-With': 'rspec'
           },
           as: :json
    end

    context 'when valid name' do
      let(:current_player) do
        {
          name: 'Rutan'
        }
      end

      it do
        subject
        expect(response).to have_http_status(:created)
        expect(response_json[:status]).to eq 'success'
        expect(response_json.dig(:data, :current_player, :name)).to eq current_player[:name]
        expect(response_json.dig(:data, :token)).to be_truthy
      end
    end
  end

  describe 'PUT /update' do
    subject do
      put api_game_current_player_url(
        game_name: game.name,
        current_player:
      ),
          headers: {
            Authorization: authorization_header,
            'X-Requested-With': 'rspec'
          },
          as: :json
    end

    context 'when valid parameters' do
      let(:player) { create(:player, game:) }
      let(:authorization_header) { "Bearer #{player.generate_token}" }
      let(:current_player) do
        {
          name: 'Rutan',
          shared_save_attributes: {
            data: '良いデータ'
          }
        }
      end

      it do
        subject
        expect(response).to have_http_status(:ok)
        expect(response_json[:status]).to eq 'success'
        expect(response_json.dig(:data, :current_player, :name)).to eq current_player[:name]
        expect(response_json.dig(:data, :current_player, :shared_save,
                                 :data)).to eq current_player[:shared_save_attributes][:data]
      end
    end

    context 'when name only' do
      let(:player) do
        create(:player, game:).tap do |ins|
          ins.shared_save.update(data: shared_value)
        end
      end
      let(:shared_value) { 'expect data' }
      let(:authorization_header) { "Bearer #{player.generate_token}" }
      let(:current_player) do
        {
          name: 'Rutan'
        }
      end

      it do
        subject
        expect(response).to have_http_status(:ok)
        expect(response_json[:status]).to eq 'success'
        expect(response_json.dig(:data, :current_player, :name)).to eq current_player[:name]
        expect(response_json.dig(:data, :current_player, :shared_save, :data)).to eq shared_value
      end
    end
  end
end
