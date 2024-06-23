# frozen_string_literal: true

class Wagon
  include Accessors
  include Constants
  include Validation
  include Vendor

  attr_accessor_with_history :number

  attr_reader :type

  validate :number, :presence
  validate :number, :type, String

  def initialize
    @number = generate_number
    yield self if block_given?
    validate!
  end

  # protected
  #
  # def validate!
  #   raise NotImplementedError, 'Unable to create an object of a Class that is a parent!' if instance_of?(Wagon)
  #   raise 'Vendor name must be between 2 and 50 characters long' if !vendor_name.nil? && invalid_length?(vendor_name)
  # end

  private

  def generate_number
    rand(36**5).to_s(36)
  end
end
