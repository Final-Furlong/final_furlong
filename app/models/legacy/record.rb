module Legacy
  class Record < ApplicationRecord
    self.abstract_class = true

    connects_to database: { writing: :legacy, reading: :legacy }

    def method_missing(method_name, *_args)
      self[format_attribute(method_name)]
    end

    def respond_to_missing?(method_name, include_private = false)
      lookup_methods.include?(method_name.to_s) || super
    end
  end
end

