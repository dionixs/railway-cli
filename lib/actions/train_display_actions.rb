# frozen_string_literal: true

module TrainDisplayActions
  def self.show_trains
    message = 'Показать список поездов для всех станций или для определенной? (Y/n)'
    input = InputHandler.handle_input(message)

    if input == 'y'
      show_trains_for_all_stations
    else
      show_train_for_station
    end
  end

  def self.display_trains_for_station(station)
    station.each_train_with_index do |train, index|
      type = train.type == Train::PASSENGER_TYPE ? 'пассажирский' : 'грузовой'
      index += 1
      wagons = train.wagons.size
      puts "\t#{index}. номер поезда:  #{train.number}, тип поезда: #{type}, кол-во вагонов: #{wagons}"
    end
  end

  def self.show_wagons
    puts 'Выберете поезд для просмотра списка вагонов:'
    train = TrainActions.choice_train

    puts "Список вагонов у поезда #{train.number}"
    list_wagons(train)
  end

  def self.list_wagons(train)
    train.each_wagon_with_index do |wagon, index|
      type = wagon.type == Train::PASSENGER_TYPE ? 'пассажирский' : 'грузовой'
      index += 1
      puts "\t#{index}. номер вагона: #{wagon.number} , тип вагона: #{type}"
      if wagon.type == Train::PASSENGER_TYPE
        puts "\t\tкол-во свободных мест: #{wagon.free_seats}, занятых мест: #{wagon.busy_seats}"
      else
        puts "\t\tкол-во свободного объема: #{wagon.free_volume}, занятого объема: #{wagon.busy_volume}"
      end
    end
  end

  def self.show_trains_for_all_stations
    Station.all.each do |station|
      puts "Список поездов на станции: #{station.name}"

      if station.trains.empty?
        puts "\tПоездов на станции нет!"
      else
        display_trains_for_station(station)
      end
    end
  end

  def self.show_train_for_station
    puts 'Выберете станцию из списка :'
    StationActions.show_stations
    station = InputHandler.handle_input.to_i
    station = Station.all[station - 1]
    puts "Список поездов на станции: #{station.name}"
    display_trains_for_station(station)
  end
end
