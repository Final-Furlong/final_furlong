namespace :integrity do
  desc "Check for orphaned records and data inconsistencies"
  task check: :environment do
    issues = []

    # Check for orphaned records across belongs_to associations
    ActiveRecord::Base.descendants.each do |model|
      next if model.abstract_class?
      next unless model.table_exists?

      model.reflect_on_all_associations(:belongs_to).each do |assoc|
        next if assoc.options[:optional]
        next if assoc.options[:polymorphic]

        foreign_key = assoc.foreign_key
        parent_table = assoc.klass.table_name
        child_table = model.table_name

        orphans = ActiveRecord::Base.connection.execute(<<~SQL).first
          SELECT COUNT(*) AS count FROM #{child_table}
          WHERE #{foreign_key} IS NOT NULL
            AND #{foreign_key} NOT IN (SELECT id FROM #{parent_table})
        SQL

        if orphans["count"].to_i > 0
          issues << "#{child_table}.#{foreign_key}: #{orphans['count']} orphaned records (missing #{parent_table})"
        end
      end
    rescue => e
      issues << "Error checking #{model.name}: #{e.message}"
    end

    if issues.any?
      puts "Data integrity issues found:"
      issues.each { |i| puts "  #{i}" }
      exit(1)
    else
      puts "No integrity issues found."
    end
  end
end
