# frozen_string_literal: true

module JsonHelper
  def jsend_success(data:)
    {
      status: 'success',
      data:
    }
  end

  def jsend_fail(data:)
    {
      status: 'fail',
      data:
    }
  end

  def jsend_error(message:, code: nil, data: nil)
    {
      status: 'error',
      message:,
      code:,
      data:
    }.compact
  end
end
