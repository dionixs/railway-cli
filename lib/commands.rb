# frozen_string_literal: true

module Commands
  LIST_COMMANDS = [
    'Список команд:',
    "\tcreate station - Создать станцию",
    "\tcreate train - Создать поезд",
    "\tcreate route - Создать маршрут",
    "\tmanage stations - Управление станциями в маршруте",
    "\tassign route - Назначить маршрут поезду",
    "\tadd wagons - Добавить вагоны к поезду",
    "\tremove wagons - Отцепить вагоны от поезда",
    "\tmove train - Переместить поезд по маршруту",
    "\tlist stations - Просмотреть список станций",
    "\tlist trains - Просмотреть список поездов на станции",
    "\tlist wagons - Просмотреть список вагонов у поезда",
    "\thelp - Список команд",
    "\texit - Выход"
  ].freeze

  def self.help
    puts LIST_COMMANDS
  end

  def self.create_station
    StationActions.create_station
  end

  def self.create_train
    TrainActions.create_train
  end

  def self.create_route
    RouteActions.create_route
  end

  def self.manage_stations
    RouteActions.station_control
  end

  def self.assign_route
    TrainActions.add_route_to_train
  end

  def self.add_wagons
    TrainActions.add_wagons
  end

  def self.remove_wagons
    TrainActions.remove_wagons_to_train
  end

  def self.move_train
    TrainMoveActions.move_train
  end

  def self.list_stations
    StationActions.show_stations
  end

  def self.list_trains
    TrainDisplayActions.show_trains
  end

  def self.list_wagons
    TrainDisplayActions.show_wagons
  end
end
