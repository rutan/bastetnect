# frozen_string_literal: true

FactoryBot.define do
  factory :player do
    game
    sequence :name do |n|
      "name#{n}"
    end
    status { 0 }
  end
end
