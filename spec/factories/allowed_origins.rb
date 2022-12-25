# frozen_string_literal: true

FactoryBot.define do
  factory :allowed_origin do
    game
    sequence :origin do |n|
      "sub#{n}.example.com"
    end
  end
end
