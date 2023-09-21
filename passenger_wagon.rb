# frozen_string_literal: true

class PassengerWagon < Wagon
  def initialize(wagon_number, volume)
    super
    @type = :passenger
    validate!
  end

  def take_place
    raise 'No place' if free_volume.zero?

    self.occupied_volume += 1 if free_volume.positive?
  end

  private

  def validate!(errors = [])
    errors << 'Place must be integer number' unless volume.instance_of?(Integer)
    super(errors)
  end
end
