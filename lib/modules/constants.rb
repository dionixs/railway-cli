# frozen_string_literal: true

module Constants
  PASSENGER_TYPE = :passenger
  CARGO_TYPE = :cargo

  INITIAL_SPEED = 0
  PASSENGER_SPEED = 50

  INITIAL_STATION = 0

  # три буквы или цифры в любом порядке
  # необязательный дефис (может быть, а может нет)
  # и еще 2 буквы или цифры после дефиса
  NUMBER_FORMAT = /^[a-zа-я0-9]{3}-?[a-zа-я0-9]{2}$/i
end
