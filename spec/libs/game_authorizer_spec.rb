# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameAuthorizer do
  let(:game) { create(:game) }

  describe '#generate_token' do
    subject do
      game_authorizer.generate_token
    end

    let(:game_authorizer) { described_class.new(game, player) }

    context 'when has player' do
      let(:player) { create(:player) }

      it do
        expect(subject).to be_truthy
      end
    end

    context 'when has not player' do
      let(:player) { nil }

      it do
        expect(subject).to be_nil
      end
    end
  end

  describe '#load_player!' do
    subject do
      game_authorizer.load_player!(token)
    end

    let(:game_authorizer) { described_class.new(game) }

    context 'when valid token' do
      let(:player) { create(:player, game:) }
      let :token do
        described_class.new(game, player).generate_token
      end

      it do
        subject
        expect(game_authorizer.player).to eq player
      end
    end

    context 'when expired token' do
      let(:player) { create(:player, game:) }
      let :token do
        described_class.new(game, player).generate_token(expired_at: 1.minute.ago)
      end

      it do
        expect { subject }.to raise_error(UnauthorizedError)
      end
    end

    context 'when other game token' do
      let(:player) { create(:player, game: create(:game)) }
      let :token do
        described_class.new(player.game, player).generate_token
      end

      it do
        expect { subject }.to raise_error(UnauthorizedError)
      end
    end
  end
end
