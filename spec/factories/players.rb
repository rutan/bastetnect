# frozen_string_literal: true

FactoryBot.define do
  factory :player do
    game
    sequence :name do |n|
      "name#{n}"
    end
    status { 0 }

    after(:build) do |ins|
      build(:shared_save, player: ins)
    end
  end
end
