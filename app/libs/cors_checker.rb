# frozen_string_literal: true

class CorsChecker
  def initialize(origin:, requested_with:)
    @origin = origin
    @requested_with = requested_with
  end

  attr_reader :origin, :requested_with

  def check!
    require_requested_with!
    require_origin_equal_requested_with_origin! if origin.present?
  end

  def require_requested_with!
    raise ForbiddenError, 'require "X-Requested-With" header' if requested_with.blank?
  end

  def require_origin_equal_requested_with_origin!
    raise ForbiddenError, '"Origin" and "X-Requested-With" do not match' unless requested_with_origin == origin
  end

  def requested_with_origin
    @requested_with_origin =
      begin
        uri = URI.parse(requested_with)
        if %w[http https].include?(uri.scheme)
          uri.origin
        else
          ''
        end
      rescue URI::InvalidURIError
        ''
      end
  end
end
