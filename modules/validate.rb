# frozen_string_literal: true

module Validate
  def validate? # catch errors for recues
    validate!
    true
  rescue StandardError
    false
  end
end
