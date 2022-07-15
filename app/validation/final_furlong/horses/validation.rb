module FinalFurlong
  module Horses
    module Validation
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        # Validates Horse Name.
        #
        # Validates horse name. Does not allow repeat names (checked without spaces/punctuation).
        #   Does not allow reserved keywords in name. Does not allow names longer than 18 characters.
        #
        # class Horse
        #   include FinalFurlong::Horses::Validation
        #
        #   attr_accessor :name
        #   validates_horse_name :name
        # end
        def validates_horse_name(*attr_names)
          validates_with FinalFurlong::Horses::Validation::NameValidator, _merge_attributes(attr_names)
          validates(*attr_names, length: { maximum: 18 })
        end
      end
    end
  end
end
