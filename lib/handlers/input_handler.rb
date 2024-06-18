# frozen_string_literal: true

module InputHandler
  def self.handle_input(message = nil)
    puts message if message
    print '> '
    gets&.strip&.downcase
  end
end
