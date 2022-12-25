# frozen_string_literal: true

FactoryBot.define do
  factory :scoreboard do
    game
    sequence :name do |n|
      "scoreboard_#{n}"
    end
    index { 0 }
    rank_order { :desc }
  end
end
