module Config
  module_function

  def load!
    settings_path = Rails.root.join("config/configurations")

    return unless File.directory?(settings_path)

    Dir.glob(settings_path.join("*.yml")).each do |path|
      file_name = File.basename(path, ".yml")

      const_set(
        file_name.camelize,
        Rails.application.config_for("configurations/#{file_name}")
      )
    end
  end
end

