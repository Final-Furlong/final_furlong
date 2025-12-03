# frozen_string_literal: true

class MigrateSettingsToWebsiteJson < ActiveRecord::Migration[8.1]
  def up
    Account::Setting.find_each do |setting|
      setting.website = {
        light_theme: setting.theme,
        dark_theme: setting.dark_theme,
        mode: setting.dark_mode? ? "dark" : "light",
        locale: setting.locale
      }
      setting.save(validate: false)
    end
  end

  def down
    Account::Setting.find_each do |setting|
      setting.theme = setting.website[:light_theme]
      setting.dark_theme = setting.website[:dark_theme]
      setting.dark_mode = setting.website[:mode] == "dark"
      setting.locale = setting.website[:locale]
      setting.save!
    end
  end
end

