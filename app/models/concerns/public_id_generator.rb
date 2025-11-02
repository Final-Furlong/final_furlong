module PublicIdGenerator
  extend ActiveSupport::Concern

  included do
    validates :public_id, length: { maximum: 12 }
  end
end

