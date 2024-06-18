# frozen_string_literal: true

module TrainMoveActions
  def self.move_train
    puts 'Выберете поезд для перемещения:'
    train = TrainActions.choice_train

    puts "Текущая станция: #{train.current_station}"

    move_train!(train)

    if train.wagons.empty?
      puts 'У поезда нет вагонов! Необходимо добавить вагоны к поезду!'
      TrainActions.add_wagons(train)
    end

    take_seat_or_volume(train)

    puts "Поезд перемещен на станцию: #{train.current_station}"
  end

  def self.move_train!(train)
    message = "Выберете куда переместить поезд:\n\t1 - Вперед\n\t2 - Назад\n"
    input = InputHandler.handle_input(message).to_i

    if input == 1
      train.forward
    elsif input == 2
      train.backward
    else
      puts 'Ошибка в выборе действия!'
    end
  end

  def self.take_seat_or_volume(train)
    if train.type == Train::PASSENGER_TYPE
      take_seat!(train)
      puts 'Произошла посадка пассажиров в поезд'
    else
      take_volume(train)
      puts 'Произошла погрузка в поезд'
    end
  end

  def self.take_seat!(train)
    train.each_wagon do |wagon|
      rand(0..wagon.total_seats).times do
        wagon.take_seat
      end
    end
  end

  def self.take_volume(train)
    train.each_wagon do |wagon|
      volume = rand(0..wagon.total_volume)
      wagon.take_volume(volume)
    end
  end
end
