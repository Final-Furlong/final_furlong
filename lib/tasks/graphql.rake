namespace :graphql do
  desc 'Dump the current GraphQL schema to a file'
  task dump_schema: :environment do
    # Get a string containing the definition in GraphQL IDL:
    schema_definition = FinalFurlongSchema.to_definition
    schema_path = "app/graphql/schema.graphql"
    File.write(Rails.root.join(schema_path), schema_definition)
    puts "Updated #{schema_path}"
  end

  desc 'Validates GraphQL queries against the current schema'
  task validate: :environment do
    documented_queries = 'app/graphql/schema.graphql'
    current_queries = FinalFurlongSchema.to_definition

    Validate.run_validate(documented_queries, current_queries)
  end

  module Validate
    def self.run_validate(existing_queries, new_queries)
      puts '⏳  Validating queries...'
      puts "\n"

      result = GraphQL::SchemaComparator.compare(existing_queries, new_queries)

      if result.identical?
        puts "✅  Schemas are identical"
      else
        print_changes(result)
      end
    end

    def self.print_changes(result)
      puts "Detected the following changes between schemas:"
      puts "\n"

      result.changes.each do |change|
        if change.breaking?
          puts "🛑  #{change.message}"
        elsif change.dangerous?
          puts "⚠️  #{change.message}"
        else
          puts "✅  #{change.message}"
        end
      end
    end
  end
end
