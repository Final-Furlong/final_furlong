module FinalFurlong
  module Common
    module Validation
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        # Validates date. Must be in DD/MM/YYYY format.
        #
        # class User
        #   include FinalFurlong::Common::Validation
        #
        #   attr_accessor :date
        #   validates_date :date
        # end
        #
        # Options:
        # * <tt>:allow_nil</tt> - don't run this validation if value is <tt>nil</tt>
        # * <tt>:allow_blank</tt> - don't run this validation if value is <tt>blank</tt> (that includes <tt>nil</tt>)
        # * <tt>:message</tt> - custom message, default one is <tt>:date_invalid</tt>
        def validates_date(*attr_names)
          validates_with FinalFurlong::Common::Validation::DateValidator, _merge_attributes(attr_names)
        end

        # Validates Date of Birth.
        #
        # Following validation is used
        # * date can't be in future
        # * date needs to be in format DD/MM/YYYY
        # * date can't be more than 150 years
        #
        # class User
        #   include FinalFurlong::Common::Validat
        #
        #   attr_accessor :date_of_birth
        #   validates_dob :date_of_birth
        # end
        #
        # Messages are as follows
        # * <tt>:date_invalid</tt> - when date can't be parsed
        # * <tt>:dob_future</tt> - when date is in future
        # * <tt>:dob_in_far_past</tt> - when date is more than 150 years ago
        #
        # Options:
        # * <tt>:allow_nil</tt> - don't run this validation if value is <tt>nil</tt>
        # * <tt>:allow_blank</tt> - don't run this validation if value is <tt>blank</tt> (that includes <tt>nil</tt>)
        def validates_dob(*attr_names)
          validates_with FinalFurlong::Common::Validation::DateOfBirthValidator, _merge_attributes(attr_names)
        end

        # Validates date. Must be in format accepted by <tt>DateTime.parse</tt>.
        #
        # class User
        #   include FinalFurlong::Common::Validation
        #
        #   attr_accessor :datetime
        #   validates_datetime :datetime
        # end
        #
        # Options:
        # * <tt>:allow_nil</tt> - don't run this validation if value is <tt>nil</tt>
        # * <tt>:allow_blank</tt> - don't run this validation if value is <tt>blank</tt> (that includes <tt>nil</tt>)
        # * <tt>:message</tt> - custom message, default one is <tt>:datetime_invalid</tt>
        def validates_datetime(*attr_names)
          validates_with FinalFurlong::Common::Validation::DatetimeValidator, _merge_attributes(attr_names)
        end
      end
    end
  end
end
