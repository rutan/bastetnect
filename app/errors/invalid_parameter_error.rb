# frozen_string_literal: true

class InvalidParameterError < StandardError
  attr_reader :param

  def initialize(param)
    @param = param
    super("parameter is invalid: #{param}")
  end
end
