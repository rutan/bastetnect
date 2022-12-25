# frozen_string_literal: true

Rails.application.configure do
  config.exceptions_app = ->(env) do
    ErrorsController.action(:show).call(env)
  end
end
