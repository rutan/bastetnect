# frozen_string_literal: true

class ErrorsController < ApplicationController
  include ErrorHandler

  rescue_from StandardError, with: :render_500

  def show
    raise env['action_dispatch.exception']
  end
end
