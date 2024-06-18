# frozen_string_literal: true

module StationActions
  def self.create_station
    name = InputHandler.handle_input('Введите название станции:')
    StationActions.find_or_create_by(name)
  end

  def self.find_or_create_by(name = nil)
    station = Station.find(name)
    if station
      puts 'Станция уже существует!'
      station
    else
      puts 'Станция успешно создана!'
      Station.new(name)
    end
  end

  def self.show_stations
    puts 'Список станций:'
    Station.all.each_with_index do |station, index|
      puts " #{index + 1} - #{station.name}"
    end
  end
end
