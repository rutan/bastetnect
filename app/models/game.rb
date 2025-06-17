# frozen_string_literal: true

# == Schema Information
#
# Table name: games
#
#  id         :bigint           not null, primary key
#  name       :string(32)       not null
#  pem        :text             not null
#  status     :integer          default("active")
#  version    :string(32)       default("0.0.0")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_games_on_name  (name) UNIQUE
#
class Game < ApplicationRecord
  has_many :allowed_origins, dependent: :restrict_with_exception
  has_many :players, dependent: :restrict_with_exception
  has_many :game_signals, dependent: :restrict_with_exception

  validates :name,
            presence: true,
            length: { in: 1..32 },
            format: { with: /\A[a-z0-9\-_]+\z/ }
  validates :version, presence: true, format: { with: /\A\d+(?:\.\d+(?:\.\d+)?)?\z/ }

  enum :status, {
    active: 0,
    hidden: 10,
    suspended: 20,
    dead: 30
  }

  scope :visible, -> { where.not(status: :dead) }
  scope :public_visible, -> { where(status: :active).or(where(status: :suspended)) }

  after_initialize :setup_default_attributes

  def setup_default_attributes
    self.pem ||= OpenSSL::PKey::RSA.generate(2048).to_pem
  end
end
