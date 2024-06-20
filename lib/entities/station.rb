# frozen_string_literal: true

class Station
  include Accessors
  include InstanceCounter
  include Validatable

  attr_reader :name, :trains

  @stations ||= []

  class << self
    def stations
      @stations ||= []
    end

    def add_station(station)
      stations << station
    end

    def all
      stations
    end

    def find(name)
      stations.find { |t| t.name == name }
    end
  end

  def initialize(name)
    @name = name.capitalize
    @trains = []
    validate!
    self.class.add_station(self)
    register_instance
  end

  def take_train(train)
    @trains << train unless train_included?(train)
  end

  def send_train(train)
    @trains.delete(train) if train_included?(train)
  end

  def trains_by_type(type)
    @trains.filter { |t| t.type == type }.size
  end

  def each_train(&block)
    @trains.each { |t| block.call(t) }
  end

  def each_train_with_index(&block)
    @trains.each_with_index { |t, i| block.call(t, i) }
  end

  def name=(value)
    @name = value.capitalize
  end

  protected

  def validate!
    raise 'Station name cannot be blank' if name.nil?
    raise 'Station name must be between 2 and 50 characters long' if invalid_length?(name)
  end

  private

  # метод для проверки того находиться ли поезд на станции
  # вынесен в private т.к. метод должен быть доступен
  # для вызова только внутри методов take_train и send_train
  # и не должен быть доступен для вызова вне класса
  def train_included?(train)
    @trains.include?(train)
  end
end
