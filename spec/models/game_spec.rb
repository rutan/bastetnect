# frozen_string_literal: true

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
