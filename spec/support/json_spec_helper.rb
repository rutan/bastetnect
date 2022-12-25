# frozen_string_literal: true

module JsonSpecHelper
  def response_json
    @response_json ||= JSON.parse(response.body).with_indifferent_access
  end
end
