# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    # base.include InstanceMethods
  end

  module ClassMethods
    def validate(name, validator_name, *args)
      class_variable_set('@@validators'.to_sym, {
                           name.to_sym => { validator_name:, options: args }
                         })

      define_method('validate!') do
        instance_var_name = "@#{name}".to_sym
        instance_value = instance_variable_get(instance_var_name)
        validators = self.class.class_variable_get('@@validators'.to_sym)

        option = validators[name.to_sym][:options][0]

        if validators[name.to_sym][:validator_name] == :presence && (instance_value.nil? || instance_value.empty?)
          raise "#{name.capitalize} cannot be blank"
        elsif validators[name.to_sym][:validator_name] == :format && instance_value !~ option
          raise "#{name.capitalize} has invalid format"
        elsif validators[name.to_sym][:validator_name] == :type && !instance_value.is_a?(option)
          raise "#{name.capitalize} has invalid type"
        end
      end

      define_method('validate?') do
        validate!
        true
      rescue NotImplementedError
        false
      rescue StandardError
        false
      end
    end
  end
end
