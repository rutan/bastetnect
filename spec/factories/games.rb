# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    sequence :name do |n|
      "game#{n}"
    end
    version { '0.0.0' }
  end
end
