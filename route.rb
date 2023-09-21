# frozen_string_literal: true

require_relative 'modules/validate'
require_relative 'modules/instance_counter'

class Route
  include Validate
  include InstanceCounter

  attr_reader :stations

  def initialize(start_station, finish_station) # initializer
    @stations = [start_station, finish_station]
    validate!
    register_instance
  end

  def add_station(station) # add station to route
    stations.insert(-2, station)
  end

  def delete_station(station) # delete station from route
    stations.delete(station)
  end

  def view_route # view all station on route
    stations.each { |station| puts station.name}
  end

  private

  attr_writer :stations

  def validate! # raise exceptions
    raise "Station can't be nil" if stations.any?(nil)
  end
end
