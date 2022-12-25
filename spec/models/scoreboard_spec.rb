# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scoreboard do
  let(:scoreboard) { create(:scoreboard) }

  describe '#guess_rank' do
    subject do
      scoreboard.guess_rank(score)
    end

    let(:score) { 10_000 }

    context 'when empty_items' do
      it do
        expect(subject).to eq 1
      end
    end

    context 'when has items' do
      before do
        create(:scoreboard_item, scoreboard:, score: 11_000)
        create(:scoreboard_item, scoreboard:, score: 9000)
        create(:scoreboard_item, scoreboard:, score: 8000)
      end

      context 'when asc' do
        let(:scoreboard) { create(:scoreboard, rank_order: :asc) }

        it do
          expect(subject).to eq 3
        end
      end

      context 'when desc' do
        let(:scoreboard) { create(:scoreboard, rank_order: :desc) }

        it do
          expect(subject).to eq 2
        end
      end
    end

    context 'when has tie items' do
      before do
        # higher
        create(:scoreboard_item, scoreboard:, score: 10_000, updated_at: 1.minute.ago)
        create(:scoreboard_item, scoreboard:, score: 20_000, updated_at: 1.minute.since)

        # lower
        create(:scoreboard_item, scoreboard:, score: 10_000, updated_at: 1.minute.since)
      end

      it do
        expect(subject).to eq 3
      end
    end
  end
end
