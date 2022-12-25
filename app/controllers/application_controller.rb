# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Helpers
  include ErrorHandler

  helper JsonHelper

  private

  def update_request?
    request.method != 'GET'
  end
end
