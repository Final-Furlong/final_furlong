require "securerandom"

class ApplicationRecord < ActiveRecord::Base
  include Turbo::Broadcastable::ClassMethods

  primary_abstract_class

  before_create :generate_uuid

  private

  def generate_uuid_v7
    return if self.class.attribute_types["id"].type != :uuid

    self.id ||= SecureRandom.uuid_v7
  end
end

