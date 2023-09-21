# frozen_string_literal: true

require_relative 'modules/validate'
require_relative 'modules/instance_counter'

class Station
  include Validate
  include InstanceCounter

  attr_reader :name, :trains_on_station

  @@stations = []

  def self.all # return all stations, method for Station class
    @@stations
  end

  def initialize(name)# initializer
    @name = name
    @trains_on_station = []
    validate!
    @@stations << self
    register_instance
  end

  def take_train(train) # put in Train object to array
    @trains_on_station << train
  end

  def send_train(train) # put out Train object from array
    @trains_on_station.delete(train)
  end

  def each_train(&block) # filter passenger or cargo trains
    @trains_on_station.each(&block)
  end

  private

  def validate!(errors = []) # raise exceptions
    errors << "Name can't be nil" if name.nil?
    errors << "Name must be a symbol" if name.class != Symbol
    errors << "Name length must be at least 3" if name.to_s.length < 4
    raise errors.join(". ") unless errors.empty? # ?
  end
end
