ClassVariants.configure do |config|
  config.process_classes_with do |classes|
    TailwindMerge::Merger.new.merge(classes)
  end
end

