# frozen_string_literal: true

module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        instance_var_name = "@#{name}".to_sym
        define_method(name) { instance_variable_get(instance_var_name) }

        # метод который создает инстанс-метод <имя_атрибута>_history
        attr_accessor_history(name, instance_var_name)

        define_method("#{name}=".to_sym) do |value|
          instance_variable_set(instance_var_name, value)
          current_value = instance_variable_get("@#{name}_history".to_sym)
          instance_variable_set("@#{name}_history".to_sym, current_value.push(value))
        end
      end
    end

    def strong_attr_accessor(*names, options)
      raise ArgumentError, "Option :#{options.first.first} not found" unless options.key?(:type)

      names.each do |name|
        instance_var_name = "@#{name}".to_sym
        define_method(name) { instance_variable_get(instance_var_name) }
        define_method("#{name}=".to_sym) do |value|
          raise ArgumentError, 'Type of assigned value is incorrect' unless value.is_a?(options[:type])

          instance_variable_set(instance_var_name, value)
        end
      end
    end

    protected

    def attr_accessor_history(name, instance_var_name)
      define_method("#{name}_history".to_sym) do
        unless instance_variable_get("@#{name}_history".to_sym)
          instance_var_values = []
          instance_var = instance_variable_get(instance_var_name)
          instance_var_values << instance_var if instance_var
          instance_variable_set("@#{name}_history".to_sym, instance_var_values)
        end
        instance_variable_get("@#{name}_history".to_sym)
      end
    end
  end
end
