class ApplicationRecord < ActiveRecord::Base
  # include Turbo::Broadcastable::ClassMethods

  primary_abstract_class

  self.implicit_order_column = "created_at"

  private

  def global_id_string
    to_global_id.to_s
  end
end

