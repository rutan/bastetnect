# frozen_string_literal: true

# == Schema Information
#
# Table name: games
#
#  id         :bigint           not null, primary key
#  name       :string(32)       not null
#  pem        :text             not null
#  play_count :integer          default(0)
#  status     :integer          default("active")
#  version    :string(32)       default("0.0.0")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_games_on_name  (name) UNIQUE
#
require 'rails_helper'

RSpec.describe Game do
  describe '#setup_default_attributes' do
    subject :init_game do
      described_class.new
    end

    it do
      expect(init_game.pem).to include 'BEGIN RSA PRIVATE KEY'
    end
  end
end
