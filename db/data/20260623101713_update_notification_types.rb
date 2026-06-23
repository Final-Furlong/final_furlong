# frozen_string_literal: true

class UpdateNotificationTypes < ActiveRecord::Migration[8.1]
  def up
    # rubocop:disable Rails/SkipsModelValidations
    Notification.where(type: "AuctionOutbidNotification").update_all(type: "Notifications::Auction::OutbidNotification")
    Notification.where(type: "HorseBornNotification").update_all(type: "Notifications::Horse::BornNotification")
    Notification.where(type: "HorseDiedNotification").update_all(type: "Notifications::Horse::DiedNotification")
    Notification.where(type: "HorsePrematureNotification").update_all(type: "Notifications::Horse::PrematureNotification")
    Notification.where(type: "HorseRetiredNotification").update_all(type: "Notifications::Horse::RetiredNotification")
    Notification.where(type: "HorseStillbornNotification").update_all(type: "Notifications::Horse::StillbornNotification")
    Notification.where(type: "LeaseAcceptanceNotification").update_all(type: "Notifications::HorseLease::AcceptanceNotification")
    Notification.where(type: "LeaseExpiryNotification").update_all(type: "Notifications::HorseLease::ExpiryNofication")
    Notification.where(type: "LeaseOfferExpiryNotification").update_all(type: "Notifications::HorseLease::OfferExpiryNotification")
    Notification.where(type: "LeaseOfferNotification").update_all(type: "Notifications::HorseLease::OfferNotification")
    Notification.where(type: "LeaseRejectionNotification").update_all(type: "Notifications::HorseLease::RejectionNotification")
    Notification.where(type: "MareBookingApprovalNotification").update_all(type: "Notifications::Breeding::Mare::BookingApprovalNotification")
    Notification.where(type: "MareBookingDeletionNotification").update_all(type: "Notifications::Breeding::Mare::BookingDeletionNotification")
    Notification.where(type: "SaleAcceptanceNotification").update_all(type: "Notifications::HorseSale::AcceptanceNotification")
    Notification.where(type: "SaleOfferExpiryNotification").update_all(type: "Notifications::HorseSale::OfferExpiryNotification")
    Notification.where(type: "SaleOfferNotification").update_all(type: "Notifications::HorseSale::OfferNotification")
    Notification.where(type: "SaleRejectionNotification").update_all(type: "Notifications::HorseSale::RejectionNotification")
    Notification.where(type: "StudBookingRequestCancellationNotification").update_all(type: "Notifications::Breeding::Stud::BookingRequestCancellationNotification")
    Notification.where(type: "StudBookingRequestNotification").update_all(type: "Notifications::Breeding::Stud::BookingRequestNotification")
    # rubocop:enable Rails/SkipsModelValidations
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

