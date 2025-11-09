module Horses
  class LeaseTerminationRequest < ApplicationRecord
    belongs_to :lease, inverse_of: :termination_request

    validates :owner_accepted_end, inclusion: { in: [true] }, on: :owner_update
    validates :leaser_accepted_end, inclusion: { in: [true] }, on: :leaser_update
    validates :owner_accepted_end, :owner_accepted_refund,
      :leaser_accepted_end, :leaser_accepted_refund,
      inclusion: { in: [true, false] }

    def both_sides_accept?
      leaser_accepted_end && owner_accepted_end
    end

    def both_sides_accept_refund?
      leaser_accepted_refund && owner_accepted_refund
    end
  end
end

# == Schema Information
#
# Table name: lease_termination_requests
# Database name: primary
#
#  id                     :bigint           not null, primary key
#  leaser_accepted_end    :boolean          default(FALSE), not null
#  leaser_accepted_refund :boolean          default(FALSE), not null
#  owner_accepted_end     :boolean          default(FALSE), not null
#  owner_accepted_refund  :boolean          default(FALSE), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  lease_id               :bigint           not null, uniquely indexed
#
# Indexes
#
#  index_lease_termination_requests_on_lease_id  (lease_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (lease_id => leases.id)
#

