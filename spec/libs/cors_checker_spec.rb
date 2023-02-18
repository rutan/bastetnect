# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CorsChecker do
  describe '#check!' do
    subject do
      cors_checker.check!
    end

    let(:cors_checker) { described_class.new(origin:, requested_with:) }

    context 'when no origin' do
      let(:origin) { nil }

      context 'when requested_with is HTTPS URL' do
        let(:requested_with) { 'https://example.com/example.html' }

        it { is_expected.to be true }
      end

      context 'when requested_with is text' do
        let(:requested_with) { 'freeText' }

        it { is_expected.to be true }
      end

      context 'when requested_with is empty' do
        let(:requested_with) { nil }

        it do
          expect { subject }.to raise_error(ForbiddenError)
        end
      end
    end

    context 'when has origin' do
      let(:origin) { 'https://example.com' }

      context 'when requested_with is valid HTTPS URL' do
        let(:requested_with) { 'https://example.com/example.html' }

        it { is_expected.to be true }
      end

      context 'when requested_with is invalid HTTPS URL' do
        let(:requested_with) { 'https://invalid.example.com/example.html' }

        it do
          expect { subject }.to raise_error(ForbiddenError)
        end
      end

      context 'when requested_with is text' do
        let(:requested_with) { 'freeText' }

        it do
          expect { subject }.to raise_error(ForbiddenError)
        end
      end

      context 'when requested_with is empty' do
        let(:requested_with) { nil }

        it do
          expect { subject }.to raise_error(ForbiddenError)
        end
      end
    end
  end
end
