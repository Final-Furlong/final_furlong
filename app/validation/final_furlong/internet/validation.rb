module FinalFurlong
  module Internet
    module Validation
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        # Validates URL.
        #
        # Validates regular HTTP / HTTPS url
        #
        # class Post
        #   include FinalFurlong::Internet::Validation
        #
        #   attr_accessor :url
        #   validates_url :url
        # end
        #
        # Validates custom scheme
        #
        # class Upload
        #   include FinalFurlong::Internet::Validation
        #
        #   attr_accessor :url
        #   validates_url :url, schemes: %w[ftp sftp]
        # end
        #
        # Options:
        # * <tt>:schemes</tt> - Specifies scheme that should be used. By default it's using http / https.
        # * <tt>:message</tt> - custom message to show when URL is invalid. By default it's using <tt>:invalid</tt>
        # * <tt>:allow_nil</tt> - don't run this validation if value is <tt>nil</tt>
        # * <tt>:allow_blank</tt> - don't run this validation if value is <tt>blank</tt> (that includes <tt>nil</tt>)
        def validates_url(*attr_names)
          validates_with UrlValidator, _merge_attributes(attr_names)
          validates(*attr_names, length: { maximum: 2000 })
        end

        # Validates Email.
        #
        # class User
        #   include FinalFurlong::Internet::Validation
        #
        #   attr_accessor :email
        #   validates_email :email
        # end
        #
        # Options:
        # * <tt>:message</tt> - custom message to show when email is invalid. By default it's using <tt>:invalid</tt>
        # * <tt>:allow_nil</tt> - don't run this validation if value is <tt>nil</tt>
        # * <tt>:allow_blank</tt> - don't run this validation if value is <tt>blank</tt> (that includes <tt>nil</tt>)
        def validates_email(*attr_names)
          validates_with EmailValidator, _merge_attributes(attr_names)
        end

        # Validates Password.
        # It validates that password has at least
        #   * one lowercase letter
        #   * one uppercase letter
        #   * one digit
        #   * one special character (#?!@$%^&*-)
        #   * is of min. 8 characters length
        #
        # class User
        #   include FinalFurlong::Internet::Validation
        #
        #   attr_accessor :password
        #   validates_password :password
        # end
        #
        # Options:
        # * <tt>:message</tt> - custom message to show when password is invalid. By default it's using <tt>:invalid</tt>
        # * <tt>:allow_nil</tt> - don't run this validation if value is <tt>nil</tt>
        # * <tt>:allow_blank</tt> - don't run this validation if value is <tt>blank</tt> (that includes <tt>nil</tt>)
        def validates_password(*attr_names)
          validates_with PasswordValidator, _merge_attributes(attr_names)
        end
      end
    end
  end
end
