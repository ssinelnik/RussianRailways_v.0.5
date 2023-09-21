# frozen_string_literal: true

require_relative 'modules/validate'
require_relative 'modules/instance_counter'
require_relative 'modules/manufacturer'
require_relative 'modules/constants'

class Train
  include Validate
  include InstanceCounter
  include Manufacturer
  include Constants

  attr_reader :number, :wagons, :route, :wagon_number
  attr_accessor :speed

  @@trains = []
  # NUMBER_TRAIN_FORMAT = /^[a-z\d]{3}-*[a-z\d]{2}$/.freeze # example: av3a3

  def self.find(number) # class method — find train by number
    @@trains.each { |train| train.number == number}
  end

  def initialize(number) # initializer
    @number = number
    @wagons = []
    @speed = 0
    validate!
    @@trains << self
  end

  def stop # stop train and set speed = 0
    self.speed = 0
  end

  def set_route(route) # pin up route by train
    self.route = route
    self.route.stations[0].take_train(self)
    @current_station_index = 0
  end

  def add_wagon(wagon) # add wagons to train
    wagons << wagon if speed.zero? # && type == wagon.type
  end

  def remove_wagon(wagon) # remove wagons from train
    wagons.delete(wagon) if speed.zero? # && type == wagon.type
  end

  def current_route # set current route for train
    route.stations[@current_station_index]
  end

  def next_station # show next station
    route.stations[@current_station_index + 1]
  end

  def prev_station # show previous station
    route.stations[@current_station_index - 1] if @current_station_index.positive?
  end

  def move_forward # move train to next station
    return unless next_station

    current_route.send_train(self) # test
    next_station.take_train(self)
    @current_station_index += 1
  end

  def move_back # move back train to previous station
    return unless prev_station

    current_route.send_train(self)
    prev_station.take_train(self)
    @current_station_index -= 1
  end

  def each_wagons(&block)
    wagons.each(&block)
  end

  # protected

  attr_writer :route

  def validate!(errors = []) # raise exceptions
    errors << "Number can't be nil" if number.nil?
    errors << "Number should be at least 5 symbols" if number.length < 5
    errors << "Name has invalid format" if number !~ NUMBER_TRAIN_FORMAT
    raise errors.join(". ") unless errors.empty? # ?
  end
end
