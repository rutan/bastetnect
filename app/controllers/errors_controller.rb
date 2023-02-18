# frozen_string_literal: true

class ErrorsController < ApplicationController
  include ErrorHandler

  def show
    raise request.env['action_dispatch.exception']
  end
end
