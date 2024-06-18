# frozen_string_literal: true

require_relative './lib/railway'

attempt = 0
user_input = nil

Railway.welcome

Railway.run -> { user_input != 'exit' } do
  user_input = InputHandler.handle_input

  begin
    command = Railway::Menu.choice_option(user_input)
    command&.call
  rescue StandardError => e
    attempt += 1
    puts "Возникла ошибка: #{e.message}. Попробуйте еще раз!"
    puts "Попыток: #{attempt}" if attempt.positive?
    retry if attempt < 3
    puts 'Достигнуто максимальное кол-во попыток. Попробуйте позже.'
    attempt = 0
    next
  end
end
