# frozen_string_literal: true

module TrainActions
  def self.create_train
    type = choice_type

    return if type.nil?

    number = InputHandler.handle_input('Введите номер поезда:')

    return puts 'Поезд уже существует!' if Train.find(number)

    create_train!(type, number)
  end

  def self.choice_type
    message = "Введите тип поезда:\n \
    \t1. Пассажирский поезд\n \
    \t2. Грузовой поезд\n"
    type = InputHandler.handle_input(message).to_i

    return type unless type != 1 && type != 2

    puts 'Тип поезда неверен!'
  end

  def self.create_train!(type, number)
    train = type == 1 ? PassengerTrain.new(number) : CargoTrain.new(number)
    puts 'Поезд успешно создан!' if train
    train
  end

  def self.choice_train(message = nil)
    puts message if message
    Train.all.each_with_index do |train, index|
      type = train.type == Train::PASSENGER_TYPE ? 'пассажирский' : 'грузовой'
      puts "\t#{index + 1}. #{train.number}, тип поезда: #{type}"
    end
    train = InputHandler.handle_input(message).to_i
    Train.all[train - 1]
  end

  def self.add_route_to_train
    puts 'Выберете поезд:'
    train = choice_train

    puts 'Выберете маршрут для поезда:'
    route = RouteActions.choice_route(Route.all) if route.nil?

    train.add_route(route)

    puts 'Маршрут для поезда назначен!'
  end

  def self.add_wagons(train = nil)
    train = choice_train if train.nil?
    wagon_count = assign_wagon_count

    if train.type == Wagon::PASSENGER_TYPE
      total_seats = InputHandler.handle_input('Укажите кол-во мест в вагоне:').to_i
    else
      total_volume = InputHandler.handle_input('Укажите общий объем вагона:').to_i
    end

    add_wagons!(train, wagon_count, total_seats, total_volume)
  end

  def self.assign_wagon_count
    message = 'Введите кол-во вагонов которое вы хотите добавить:'
    InputHandler.handle_input(message).to_i
  end

  def self.add_wagons!(train, wagon_count, total_seats = nil, total_volume = nil)
    wagon_count.times do
      wagon = if train.type == Train::PASSENGER_TYPE
                PassengerWagon.new { |p| p.total_seats = total_seats }
              else
                CargoWagon.new { |p| p.total_volume = total_volume }
              end
      train.add_wagon(wagon)
    end
    puts 'Вагоны добавлены!' if train.wagons.size.positive?
  end

  def self.remove_wagons_to_train
    puts 'Выберете поезд:'
    train = choice_train

    wagon_count = InputHandler.handle_input('Введите кол-во вагонов для удаления:').to_i

    train.each_wagon_with_index do |wagon, index|
      train.remove_wagon(wagon) if wagon_count != index + 1
    end

    puts 'Вагоны отцеплены!'
  end
end
