# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScoreboardItem do
  describe '#can_overwrite_score?' do
    subject do
      scoreboard_item.can_overwrite_score?(score)
    end

    [
      { order: :desc, is_new: true, score: 3000, expect_result: true },
      { order: :desc, is_new: true, score: 1000, expect_result: true },
      { order: :desc, is_new: false, score: 3000, expect_result: true },
      { order: :desc, is_new: false, score: 1000, expect_result: false },
      { order: :asc, is_new: true, score: 3000, expect_result: true },
      { order: :asc, is_new: true, score: 1000, expect_result: true },
      { order: :asc, is_new: false, score: 3000, expect_result: false },
      { order: :asc, is_new: false, score: 1000, expect_result: true }
    ].each do |pattern|
      context [
        'when',
        "rank_order is #{pattern[:order]},",
        "#{pattern[:is_new] ? 'new_record' : 'update_record'},",
        (pattern[:score] > 2000 ? 'higher_score' : 'lower_score').to_s
      ].join(' ') do
        let(:scoreboard) { create(:scoreboard, rank_order: pattern[:order]) }
        let(:scoreboard_item) do
          if pattern[:is_new]
            build(:scoreboard_item, scoreboard:, score: 2000)
          else
            create(:scoreboard_item, scoreboard:, score: 2000)
          end
        end
        let(:score) { pattern[:score] }

        it do
          expect(subject).to eq pattern[:expect_result]
        end
      end
    end
  end
end
