# frozen_string_literal: true

# ------------ modules ------------
require_relative 'modules/instance_counter'
require_relative 'modules/validate'
require_relative 'modules/manufacturer'
require_relative 'modules/constants'

# ------------ classes ------------
require_relative 'station'
require_relative 'train'
require_relative 'route'
require_relative 'wagon'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_train'
require_relative 'passenger_train'

class MainMenu
  include Constants

  MENU = [
    { index: 1, title: 'create new station', action: :create_new_station },
    { index: 2, title: 'create new train', action: :create_new_train },
    { index: 3, title: 'create new wagon', action: :create_new_wagon },
    { index: 4, title: 'create new route and manage it', action: :manage_route },
    { index: 5, title: 'set route for train', action: :set_route },
    { index: 6, title: 'add wagon to the train', action: :add_wagons_to_train },
    { index: 7, title: 'remove wagon from train', action: :remove_wagon_from_train },
    { index: 8, title: 'move train on the route', action: :move_train_on_route },
    { index: 9, title: 'show stations and trains at the station', action: :show_station_and_trains },
    { index: 10, title: 'show train and wagons on train', action: :show_train_and_wagons },
    { index: 11, title: 'book place in wagon', action: :take_place },
    { index: 12, title: 'occupy volume in wagon', action: :accupy_volume },
    { index: 13, title: 'call big_list', action: :big_list }
  ].freeze

  MENU_ROUTE = [
    { index: 1, title: 'create new route', action: :create_new_route },
    { index: 2, title: 'add station on route', action: :add_station },
    { index: 3, title: 'delete station from route', action: :delete_station }
  ].freeze

  MENU_MOVE_TRAIN = [
    { index: 1, title: 'move train on route to next station', action: :move_forward },
    { index: 2, title: 'move train on route to previous station', action: :move_back }
  ].freeze

  def initialize # initializer
    @stations = []
    @routes = []
    @trains = []
    @wagons = []
    main_menu
  end

  def main_menu # open main menu loop
    loop do
      puts 'Enter your choice'
      MENU.each { |item| puts "#{item[:index]}: #{item[:title]}" }
      choice = gets.chomp.to_i
      need_item = MENU.find { |item| item[:index] == choice }
      send(need_item[:action])
      puts "Enter '0' for continue or any key for exit"
      break unless gets.chomp.to_i.zero?
    end
  end

  # private

  def create_new_station # create new station
    puts 'Enter new station name -> '
    name = gets.chomp.to_sym
    @stations << Station.new(name)
    puts "Created new station: #{name}"
  end

  def create_new_train
    type = get_type
    number = get_number_train
    create_train(type, number)
  end

  def get_type
    puts 'Enter 1 for create passenger [train/wagon]'
    puts 'Enter 2 for create cargo [train/wagon]'
    choice = gets.chomp.to_i
    raise 'Invalid enter! Please, repeat!' unless [1, 2].include?(choice)

    choice
  rescue RuntimeError => e
    puts e
    retry
  end

  def get_number_train
    puts 'Enter new train number'
    number = gets.chomp.to_s
    raise 'Invalid number! Please, repeat!' if number !~ NUMBER_TRAIN_FORMAT

    number
  rescue RuntimeError => e
    puts e
    retry
  end

  def create_train(type, number)
    case type
    when 1
      @trains << PassengerTrain.new(number)
    when 2
      @trains << CargoTrain.new(number)
    end
    puts "Create new train with number: #{number}"
  end

  def create_new_wagon
    type = get_type
    number = get_number_wagon
    volume = get_volume(type)
    create_wagon(type, number, volume)
  end

  def get_number_wagon
    puts 'Enter wagon number'
    number = gets.chomp.to_s
    raise 'Invalid number! Please, repeat!' if number !~ NUMBER_WAGON_FORMAT

    number
  rescue RuntimeError => e
    puts e
    retry
  end

  def get_volume(type)
    case type
    when 1
      get_place!
    when 2
      get_volume!
    end
  end

  def get_place!
    puts 'Please enter place number'
    place = gets.chomp.to_i
    raise 'Invalid number place' if place < 1

    place
  rescue RuntimeError => e
    puts e
    retry
  end

  def get_volume!
    puts 'Please enter volume'
    volume = gets.chomp.to_f
    raise 'Invalid volume' if volume <= 0

    volume
  rescue RuntimeError => e
    puts e
    retry
  end

  def create_wagon(type, number, volume)
    case type
    when 1
      @wagons << PassengerWagon.new(number, volume)
    when 2
      @wagons << CargoWagon.new(number, volume)
    end
    puts "New wagon created with number: #{number}"
  end

  def take_place
    puts 'Enter wagon number for booking place'
    wagon = gets.chomp.to_sym
    wagon.take_place!
  end

  def occupy_volume
    puts 'Enter wagon number for occupying volume'
    wagon = gets.chomp.to_sym
    puts 'Enter volume for occupy'
    volume = gets.chomp.to_f
    wagon.occupy_volume!(volume)
  end

  def manage_route
    puts 'Enter your choice'
    MENU_ROUTE.each { |item| puts "#{item[:index]}: #{item[:title]}" }
    choice = gets.chomp.to_i
    need_item = MENU_ROUTE.find { |item| item[:index] == choice }
    send(need_item[:action])
  end

  def create_new_route
    puts 'Enter first station on route'
    first_station = gets.chomp.to_sym
    puts 'Enter last station on route'
    last_station = gets.chomp.to_sym
    @routes << Route.new(first_station, last_station)
  end

  def add_station
    puts 'Enter station name on route'
    station = gets.chomp.to_sym
    route = select_from_collection(@routes)
    route.add_station(station)
  end

  def delete_station
    station = select_from_collection(@stations)
    route = select_from_collection(@routes)
    route.delete_station(station)
  end

  def set_route
    train = select_from_collection(@trains)
    route = select_from_collection(@routes)
    train.set_route(route)
  end

  def add_wagons_to_train
    puts 'Enter train name'
    usr_train = gets.chomp.to_sym
    puts 'Enter wagon name'
    usr_wagon = gets.chomp.to_sym
    find_in_history(usr_train).add_wagon(find_in_history(usr_wagon))
  end

  def remove_wagons_from_train
    puts 'Enter name of object class train for remove wagons'
    train = gets.chomp.to_sym
    puts 'Enter name of object class wagons for remove from train'
    wagons = gets.chomp.to_sym
    train.remove_wagon(wagons)
    puts 'Error, train not stop!' unless speed.zero?
    puts 'Error of type carriages' unless train.type == wagons.type
  end

  def move_train_on_route
    puts 'Enter your choice'
    MENU_MOVE_TRAIN.each { |item| puts "#{item[:index]}: #{item[:title]}" }
    choice = gets.chomp.to_i
    need_item = MENU_MOVE_TRAIN.find { |item| item[:index] == choice }
    send(need_item[:action])
  end

  def move_forward
    train = select_from_collection(@trains)
    train.move_forward
  end

  def move_back
    train = select_from_collection(@trains)
    train.move_back
  end

  def show_station_and_trains
    station = select_from_collection(@stations)
    puts "Trains on station #{station}:"
    station.each_train do |train|
      puts "Number wagon: #{train.number}, type train: #{train.type}, wagons: #{train.wagons.size}"
    end
  end

  def show_train_and_wagons
    train = select_from_collection(@trains)
    puts "Wagons on train #{train}:"
    train.each_wagons do |wagon|
      puts "Wagon number: #{wagon.wagon_number}, wagon type: #{wagon.type},
      free place(volume): #{wagon.free_volume}, occupied place(volume): #{wagon.occupied_volume}"
    end
  end

  def show_collection(collection)
    collection.each.with_index(1) { |item, index| puts "#{index}: #{item}" }
  end

  def select_from_collection(collection)
    show_collection(collection)
    index = gets.to_i - 1
    return if index.negative?

    collection[index]
  end

  def big_list
    puts @trains
    puts @stations
    puts @routes
    puts @wagons
  end

  MainMenu.new
end
