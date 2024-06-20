# frozen_string_literal: true

require_relative './modules/acсessors'
require_relative './modules/constants'
require_relative './modules/validatable'
require_relative './modules/instance_counter'
require_relative './modules/vendor'

require_relative './entities/station'
require_relative './entities/route'
require_relative './entities/train'
require_relative './entities/wagon'
require_relative './entities/cargo_train'
require_relative './entities/passenger_train'
require_relative './entities/cargo_wagon'
require_relative './entities/passenger_wagon'

require_relative './handlers/input_handler'

require_relative './actions/station_actions'
require_relative './actions/train_actions'
require_relative './actions/route_actions'
require_relative './actions/train_display_actions'
require_relative './actions/train_move_actions'

require_relative './commands'

require_relative '../seed/seed'

module Railway
  module Menu
    OPTIONS = {
      help: Commands.method(:help),
      create_station: Commands.method(:create_station),
      create_train: Commands.method(:create_train),
      create_route: Commands.method(:create_route),
      manage_stations: Commands.method(:manage_stations),
      assign_route: Commands.method(:assign_route),
      add_wagons: Commands.method(:add_wagons),
      remove_wagons: Commands.method(:remove_wagons),
      move_train: Commands.method(:move_train),
      list_stations: Commands.method(:list_stations),
      list_trains: Commands.method(:list_trains),
      list_wagons: Commands.method(:list_wagons)
    }.freeze

    def self.choice_option(input)
      return if input == 'exit'

      command = input&.split(' ')&.join('_')&.to_sym
      OPTIONS[command] || command_not_found(command)
    end

    def self.command_not_found(command)
      puts "\nКоманда #{command} не найдена!"
    end
  end

  def self.welcome
    puts 'Добро пожаловать в систему управления железн. станциями!'
    puts 'Введите help для просмотра списка команд'
  end

  def self.run(condition)
    loop do
      break unless condition.call

      yield
    end
  rescue Interrupt
    puts
  end
end
