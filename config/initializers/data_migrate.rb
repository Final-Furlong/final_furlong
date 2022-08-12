require "data_migrate"

module DataMigrate
  module OnlyPrimaryDatabase
    def each_current_configuration(environment, name = nil)
      # Ignore secondary database(s)
      super(environment, name || "primary")
    end
  end
end

DataMigrate::DatabaseTasks.extend DataMigrate::OnlyPrimaryDatabase

DataMigrate.configure do |config|
  config.db_configuration = Rails.configuration.database_configuration[Rails.env]["primary"]
end

