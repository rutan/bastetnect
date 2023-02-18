# frozen_string_literal: true

module ErrorHandler
  extend ActiveSupport::Concern
  include JsonHelper

  included do
    rescue_from StandardError, with: :render_500 unless Rails.env.development?

    rescue_from ActionDispatch::Http::Parameters::ParseError, with: :render_400
    rescue_from ActionController::ParameterMissing, with: :render_400_by_parameter_missing
    rescue_from InvalidParameterError, with: :render_400_by_invalid_parameter
    rescue_from ActiveRecord::RecordInvalid, with: :render_400_by_record_invalid
    rescue_from UnauthorizedError, with: :render_401
    rescue_from ForbiddenError, with: :render_403
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from ActionController::RoutingError, with: :render_404
  end

  def render_400
    render json: jsend_fail(
      data: { message: 'bad_request' }
    ), status: :unauthorized
  end

  def render_400_by_parameter_missing(error)
    render json: jsend_fail(
      data: {
        message: 'bad_request',
        details: "missing parameter \"#{error.param}\""
      }
    ), status: :bad_request
  end

  def render_400_by_invalid_parameter(error)
    render json: jsend_fail(
      data: {
        message: 'bad_request',
        details: "invalid parameter \"#{error.param}\""
      }
    ), status: :bad_request
  end

  def render_400_by_record_invalid(error)
    render json: jsend_fail(
      data: {
        message: 'bad_request',
        details: error.record.errors.full_messages
      }
    ), status: :bad_request
  end

  def render_401(error)
    render json: jsend_fail(
      data: { message: 'unauthorized', details: error.message }
    ), status: :unauthorized
  end

  def render_403(error)
    render json: jsend_fail(
      data: { message: 'forbidden', details: error.message }
    ), status: :forbidden
  end

  def render_404
    render json: jsend_error(message: 'not_found'), status: :not_found
  end

  def render_500
    render json: jsend_error(message: 'internal_server_error'), status: :internal_server_error
  end
end
