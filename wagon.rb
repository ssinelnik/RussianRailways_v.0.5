# frozen_string_literal: true

require_relative 'modules/instance_counter'
require_relative 'modules/manufacturer'
require_relative 'modules/validate'
require_relative 'modules/constants'

class Wagon
  include InstanceCounter
  include Manufacturer
  include Validate
  include Constants

  attr_reader :type, :wagon_number, :volume, :occupied_volume

  # NUMBER_WAGON_FORMAT = /^[a-z\d]{1}[a-z\d]{1}?$/.freeze # example: a2

  def initialize(wagon_number, volume) # initializer
    @wagon_number = wagon_number
    @volume = volume
    @occupied_volume = 0
    validate!
    register_instance
  end

  def free_volume # return free volume
    volume - occupied_volume
  end

  protected

  attr_writer :occupied_volume

  def validate!(errors = []) # raise exceptions
    errors << "Volume can't be nil" if volume.nil?
    errors << "Volume can't be zero" if volume.zero?
    errors << "Volume must be positive" if volume.to_f.negative?
    errors << "Invalid wagon number" if wagon_number !~ NUMBER_WAGON_FORMAT
    raise errors.join('. ') unless errors.empty? # ?
  end
end
