# frozen_string_literal: true

class UpdateTypeForFutureEntryNotification < ActiveRecord::Migration[8.1]
  def up
    # rubocop:disable Rails/SkipsModelValidations
    Notification.where(type: "FutureEntryProcessingNotification").update_all(type: "::Notifications::Racing::FutureEntryProcessingNotification")
    # rubocop:enable Rails/SkipsModelValidations
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

