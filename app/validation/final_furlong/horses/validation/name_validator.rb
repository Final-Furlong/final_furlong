module FinalFurlong
  module Horses
    module Validation
      class NameValidator < ActiveModel::EachValidator
        RESERVED_VALUES = ["Final Furlong"].freeze
        UNNAMED = "Unnamed".freeze

        # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

        def validate_each(record, attribute, value)
          return if value.nil? && options[:allow_nil]
          return if value.blank? && options[:allow_blank]

          record.errors.add(attribute, :invalid, value:) if value&.casecmp(UNNAMED)&.zero?
          reserved_names = RESERVED_VALUES.any? { |string| value.to_s.include?(string) }
          record.errors.add(attribute, :invalid, value:) if reserved_names

          matching_name = ::Horses::HorsesQuery.call(name: value).exists?
          record.errors.add(attribute, :non_unique, value:) if matching_name
        end

        # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      end
    end
  end
end

