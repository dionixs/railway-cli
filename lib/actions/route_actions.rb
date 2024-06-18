# frozen_string_literal: true

module RouteActions
  def self.create_route(stations = Station.all)
    start_station = choice_station('Выберете начальную станцию из списка ниже:')
    end_station = choice_station('Выберете конечную станцию из списка ниже:')

    if start_station == end_station
      puts 'Начальная и конечная станции совпадают!'
    else
      start_station = stations[start_station - 1] if start_station.is_a?(Integer)
      end_station = stations[end_station - 1] if end_station.is_a?(Integer)
      route = Route.new(start_station, end_station)
    end
    station_control(route)
  end

  def self.station_control(route = nil)
    if route.nil?
      puts 'Выберете маршрут для изменения:'
      route = RouteActions.choice_route(Route.all)
    end
    action = choice_action
    puts action
    station_control!(action, route)
  end

  def self.station_control!(action, route = nil)
    if action == 1
      add_station(route)
    elsif action == 2
      remove_station(route)
    else
      puts 'Ошибка в выборе действия!'
    end
  end

  def self.choice_route(routes)
    show_routes
    route = InputHandler.handle_input.to_i
    routes[route - 1]
  end

  def self.show_routes
    Route.all.each_with_index do |route, index|
      print " #{index + 1}: "
      route.all_stations
      puts
    end
  end

  def self.add_station(route)
    station = StationActions.create_station
    route.add_station(station)
    puts 'Станция успешно добавлена в маршрут!'
  end

  def self.remove_station(route)
    puts 'Выберете какую станцию вы хотите удалить:'
    StationActions.show_stations
    station = InputHandler.handle_input.to_i
    station = route.stations[station - 1]
    puts route.remove_station(station)
  end

  def self.choice_station(message)
    puts message
    StationActions.show_stations
    InputHandler.handle_input.to_i
  end

  def self.choice_action
    puts 'Выберете действие:'
    puts ' 1 - Добавить промеж. станцию'
    puts ' 2 - Удалить промеж. станцию'
    print '> '
    gets.to_i
  end
end
