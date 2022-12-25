# frozen_string_literal: true

class BytesizeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    check_minimum(record, attribute, value)
    check_maximum(record, attribute, value)
  end

  private

  def check_minimum(record, attribute, value)
    return unless options[:minimum]
    return if value.to_s.bytesize >= options[:minimum]

    record.errors.add(attribute, :too_small_bytesize)
  end

  def check_maximum(record, attribute, value)
    return unless options[:maximum]
    return if value.to_s.bytesize <= options[:maximum]

    record.errors.add(attribute, :too_large_bytesize)
  end
end
