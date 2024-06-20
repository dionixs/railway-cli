# frozen_string_literal: true

class Route
  include Accessors
  include InstanceCounter
  include Validatable

  @routes ||= []

  class << self
    def routes
      @routes ||= []
    end

    def add_route(route)
      routes << route
    end

    def all
      routes
    end
  end

  attr_reader :stations, :start_station, :end_station

  def initialize(start_station, end_station)
    @start_station = start_station
    @end_station = end_station
    @stations = [start_station, end_station]
    validate!
    self.class.add_route(self)
    register_instance
  end

  def add_station(station)
    @stations.insert(-2, station) unless station_included?(station)
  end

  def remove_station(station)
    return 'Начальная/конечная станция не может быть удалена!' if not_start_or_end?(station)

    @stations.delete(station) if station_included?(station)
    'Станция успешно удалена!'
  end

  def all_stations
    @stations.each_with_index { |s, i| print @stations.size > (i + 1) ? "#{s.name} > " : s.name }
  end

  protected

  def validate!
    raise 'Start station name cannot be blank' if start_station.name.nil?
    raise 'End station name cannot be blank' if end_station.name.nil?
    raise 'Start station name must be between 2 and 50 characters long' if invalid_length?(start_station.name)
    raise 'End station name must be between 2 and 50 characters long' if invalid_length?(end_station.name)
  end

  private

  # метод проверяет есть ли станция
  # в текущем маршруте (массиве @stations)
  # вынесен в private т.к. метод не должен быть доступен
  # для вызова вне класса и должен вызываться
  # только внутри методов add_station и remove_station
  def station_included?(station)
    @stations.include?(station)
  end

  # метод проверяет являеться ли станция начальной или конечной
  # вынесен в private т.к. метод не должен быть доступен
  # для вызова вне класса и должен вызываться
  # только внутри метода remove_station
  def not_start_or_end?(station)
    station == @stations[0] || station == @stations[-1]
  end
end
