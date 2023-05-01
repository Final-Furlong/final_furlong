require_relative '../contracts/all_models'

class ApplicationRecord < ActiveRecord::Base
  include Turbo::Broadcastable::ClassMethods

  primary_abstract_class

  self.implicit_order_column = "created_at"
end

