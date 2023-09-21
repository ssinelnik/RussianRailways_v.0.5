# irb script :
=begin
load './main_menu.rb'
station_1 = Station.new(:Chel)
station_2 = Station.new(:Samar)
station_3 = Station.new(:Vlad)
route_1 = Route.new(station_1, station_3)
route_1.add_station(station_2)
train_1 = Train.new(:av3a3)
wagon_1 = Wagon.new(:a1, 1300)
wagon_2 = Wagon.new(:a2, 1400)
wagon_3 = Wagon.new(:a3, 1500)
train_1.set_route(route_1)
train_1.add_wagon(wagon_1)
train_1.add_wagon(wagon_2)
train_1.add_wagon(wagon_3)
=end
