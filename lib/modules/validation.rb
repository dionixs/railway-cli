# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    # base.include InstanceMethods
  end

  module ClassMethods
    def validate(name, validator_name, *args)
      class_variable_set('@@validators'.to_sym, {}) unless class_variable_defined?(:@@validators)
      validators = class_variable_get('@@validators'.to_sym)
      validators[name.to_sym] = {} if validators[name.to_sym].nil?
      validators[name.to_sym][validator_name.to_sym] = args
      class_variable_set('@@validators'.to_sym, validators)

      define_method('validate!') do
        validators = self.class.class_variable_get('@@validators'.to_sym)
        validators.each do |instance_var_name, value|
          instance_value = instance_variable_get("@#{instance_var_name}".to_sym)
          if value[:presence] && (instance_value.nil? || instance_value.empty?)
            raise "#{name.capitalize} cannot be blank"
          end
          raise "#{name.capitalize} has invalid format" if !value[:format].nil? && instance_value !~ value[:format][0]
          raise "#{name.capitalize} has invalid type" unless instance_value.is_a?(value[:type][0])
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
