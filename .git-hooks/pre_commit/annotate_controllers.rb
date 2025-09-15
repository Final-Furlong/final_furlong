module Overcommit::Hook::PreCommit # rubocop:disable Style/ClassAndModuleChildren
  # Annotate controllers automatically
  class AnnotateControllers < Base
    def run
      changed_files = execute(["git", "diff", "--staged", "--name-only"])
      return :fail, "Could not get changed files" unless changed_files.success?

      routes_changed = changed_files.stdout.split("\n").include?("config/routes.rb")
      return :pass unless routes_changed

      result = execute(["bundle", "exec", "annotaterb", "models"])
      return :fail, "Models have been annotated" unless result.success?

      result = execute(["bundle", "exec", "annotaterb", "routes"])
      return :fail, "Routes have been annotated" unless result.success?

      :pass
    end
  end
end

