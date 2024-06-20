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
        attr_accessor_history(name, instance_var_name)
        define_method("#{name}=".to_sym) do |value|
          instance_variable_set(instance_var_name, value)
          current_value = instance_variable_get("@#{name}_history".to_sym)
          instance_variable_set("@#{name}_history".to_sym, current_value.push(value))
        end
      end
    end

    private

    def attr_accessor_history(name, instance_var_name)
      define_method("#{name}_history".to_sym) do
        unless instance_variable_get("@#{name}_history".to_sym)
          instance_var_names = []
          instance_var_names << instance_variable_get(instance_var_name) if instance_variable_get(instance_var_name)
          instance_variable_set("@#{name}_history".to_sym, instance_var_names)
        end
        instance_variable_get("@#{name}_history".to_sym)
      end
    end
  end
end
