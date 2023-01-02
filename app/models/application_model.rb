require "dry-types"
require "dry-struct"

module Types
  include Dry.Types()
end

class ApplicationModel < ROM::Struct
  UUID = Types::String.default { SecureRandom.uuid }

  def self.inherited(klass)
    super

    klass.extend ActiveModel::Naming
    klass.include ActiveModel::Conversion

    klass.transform_types { |t| t.required(false) }
  end

  def persisted?
    respond_to?(:id) && id.present?
  end
end

