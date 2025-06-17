# frozen_string_literal: true

require 'rails_helper'

describe BytesizeValidator, type: :validator do
  describe '#validate' do
    subject do
      dummy_class = Struct.new(:data) do
        include ActiveModel::Validations

        def self.name
          'Dummy'
        end
      end
      dummy_class.validates :data, bytesize: validate_option
      dummy_class.new(data)
    end

    context 'when use minimum options' do
      let(:validate_option) do
        {
          minimum: 100.bytes
        }
      end

      context 'when greater than' do
        let(:data) { 'a' * 101.bytes }

        it { is_expected.to be_valid }
      end

      context 'when equal' do
        let(:data) { 'a' * 100.bytes }

        it { is_expected.to be_valid }
      end

      context 'when less than' do
        let(:data) { 'a' * 99.bytes }

        it { is_expected.not_to be_valid }
      end
    end

    context 'when use maximum options' do
      let(:validate_option) do
        {
          maximum: 100.bytes
        }
      end

      context 'when less than' do
        let(:data) { 'a' * 99.bytes }

        it { is_expected.to be_valid }
      end

      context 'when equal' do
        let(:data) { 'a' * 100.bytes }

        it { is_expected.to be_valid }
      end

      context 'when greater than' do
        let(:data) { 'a' * 101.bytes }

        it { is_expected.not_to be_valid }
      end
    end
  end
end
