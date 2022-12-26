# frozen_string_literal: true

class SharedSave < ApplicationRecord
  MAX_SHARED_DATA_BYTESIZE = 4.kilobytes

  belongs_to :player

  validates :player,
            uniqueness: true
  validates :data,
            bytesize: { maximum: MAX_SHARED_DATA_BYTESIZE },
            allow_nil: false
end
