# frozen_string_literal: true

FactoryBot.define do
  factory :shared_save do
    player
    data { "data:#{rand}" }
  end
end
