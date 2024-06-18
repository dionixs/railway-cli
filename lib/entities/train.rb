# frozen_string_literal: true

class Train
  include Constants
  include InstanceCounter
  include Validatable
  include Vendor

  @trains ||= []

  class << self
    def trains
      @trains ||= []
    end

    def all
      ObjectSpace.each_object(self).to_a
    end

    def find(number)
      all.find { |t| t.number == number }
    end
  end

  attr_reader :number, :type, :wagons,
              :speed, :stations

  def initialize(number)
    @number = number
    @wagons = []
    @stations = []
    @speed = INITIAL_SPEED
    @station = INITIAL_STATION
    validate!
    self.class.trains << self
    register_instance
  end

  def go
    @speed = PASSENGER_SPEED
  end

  def stop
    @speed = INITIAL_SPEED
  end

  def add_wagon(wagon)
    @wagons << wagon if can_attach?(wagon)
  end

  def remove_wagon(wagon)
    @wagons.delete(wagon) if can_detach?(wagon)
  end

  def add_route(route)
    @stations = route.stations
  end

  def current_station
    @stations[@station].name
  end

  def show_forward_station
    return start_station_name if start_station?

    forward_station_name
  end

  def show_backward_station
    return end_station_name if end_station?

    backward_station_name
  end

  def forward
    return if @station == @stations.size - 1

    @station += 1
    @stations[@station]
  end

  def backward
    return @stations[@station] if @station.zero?

    @station -= 1
    @stations[@station]
  end

  def each_wagon(&block)
    @wagons.each { |w| block.call(w) }
  end

  def each_wagon_with_index(&block)
    @wagons.each_with_index { |w, i| block.call(w, i) }
  end

  protected

  def validate!
    raise NotImplementedError, 'Cannot instantiate parent class!' if instance_of?(Train)
    raise 'Number cannot be blank' if number.nil?
    raise 'Number must be between 5..6 characters long' if invalid_length?(number, 5, 6)
    raise 'Number has invalid format' if number !~ NUMBER_FORMAT
    raise 'Vendor name must be between 2..50 characters long' if valid_vendor_name?
  end

  private

  # метод который проверяет можно ли прицепить вагон
  # вынесен в private так как должен быть доступен
  # только внутри методов add_wagon и remove_wagon
  def can_attach?(wagon)
    @speed.zero? && type_match?(wagon)
  end

  # для лучшей читабельности метод can_attach?
  # имеет алиас can_detach?, который применяеться
  # для проверки того можно ли отцепить вагон
  alias can_detach? can_attach?

  # метод проверяет равен ли тип вагона типу поезда
  # вынесен в private так как должен быть доступен
  # только внутри метода can_attach?/can_detach?
  def type_match?(wagon)
    wagon.type == type
  end

  # метод который возвращает название начальной станции
  # вынесен в private т.к. метод
  # используеться только внутри метода show_forward_station
  def start_station_name
    @stations[0].name
  end

  # метод который возвращает название конечной станции
  # вынесен в private т.к. метод
  # используеться только внутри метода show_backward_station
  def end_station_name
    @stations[-1].name
  end

  # метод проверки начальной станции
  # вынесен в private т.к. метод
  # используеться только внутри метода show_forward_station
  def start_station?
    @station.zero?
  end

  # метод проверки конечной станции
  # вынесен в private т.к. метод
  # используеться только внутри метода show_backward_station
  def end_station?
    @station == @stations.size
  end

  # метод который возвращает название след. станции
  # вынесен в private т.к. метод
  # используеться только внутри метода show_forward_station
  def forward_station_name
    @stations[@station + 1].name
  end

  # метод который возвращает название пред. станции
  # вынесен в private т.к. метод
  # используеться только внутри метода show_backward_station
  def backward_station_name
    @stations[@station - 1].name
  end
end
