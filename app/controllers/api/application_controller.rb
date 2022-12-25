# frozen_string_literal: true

module Api
  class ApplicationController < ::ApplicationController
    private

    def param_page(max = 100)
      (params[:page] || 1).to_i.tap do |page|
        raise InvalidParameterError, :page unless page.between?(1, max)
      end
    end

    def param_limit(max: 100, default_value: 100)
      (params[:limit] || default_value).to_i.tap do |limit|
        raise InvalidParameterError, :limit unless limit.between?(1, max)
      end
    end
  end
end
