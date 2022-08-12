module FinalFurlong
  module Horses
    module Validation
      class NameValidator < ActiveModel::EachValidator
        RESERVED_VALUES = ["Final Furlong"].freeze
        UNNAMED = "Unnamed".freeze

        def validate_each(record, attribute, value) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize
          return if value.nil? && options[:allow_nil]
          return if value.blank? && options[:allow_blank]

          record.errors.add(attribute, :invalid, value:) if value&.casecmp(UNNAMED)&.zero?
          reserved_names = RESERVED_VALUES.any? { |string| value.to_s.include?(string) }
          record.errors.add(attribute, :invalid, value:) if reserved_names

          matching_name = HorsesQuery.call(name: value).exists?
          record.errors.add(attribute, :non_unique, value:) if matching_name
        end
      end
    end
  end
end

