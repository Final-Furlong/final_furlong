# ------------
# Looks at every .rb file in the lib/tasks and adds them to rake within the
# namespace of their subdirectories
# ------------

# Important to note we are looking specifically for .rb files, so they
# aren't added to the global rake namespace
Dir.glob(Rails.root.join("lib/tasks/**/*.rb").to_s).each do |file|
  path = file.split("/")
  namespaces = path[(path.index("tasks") + 1)..-2]
  path.last
  if namespaces.size > 0
    namespace namespaces[0].to_sym do
      if namespaces.size > 1
        while namespaces.size > 1
          namespaces = namespaces[1..]
          namespace namespaces[0].to_sym do
            load file if namespaces.size > 0
          end
        end
      else
        load file
      end
    end
  else
    load file
  end
end

