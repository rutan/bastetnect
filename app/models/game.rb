# frozen_string_literal: true

class Game < ApplicationRecord
  has_many :players, dependent: :restrict_with_exception
  has_many :game_signals, dependent: :restrict_with_exception

  validates :name,
            presence: true,
            length: { in: 1..32 },
            format: { with: /\A[a-z0-9\-_]+\z/ }
  validates :version, presence: true, format: { with: /\A\d+(?:\.\d+(?:\.\d+)?)?\z/ }
  validates :play_count, inclusion: { in: 0.. }

  enum :status, {
    active: 0,
    hidden: 10,
    frozen: 20,
    dead: 30
  }

  scope :visible, -> { where.not(status: :dead) }
  scope :public_visible, -> { where(status: :active).or(where(status: :frozen)) }

  after_initialize :setup_default_attributes

  def setup_default_attributes
    self.pem ||= OpenSSL::PKey::RSA.generate(2048).to_pem
  end
end
