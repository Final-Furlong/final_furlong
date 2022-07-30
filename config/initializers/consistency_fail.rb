if Object.const_defined?(:ConsistencyFail)
  class ConsistencyFail::Introspectors::Polymorphic # rubocop:disable Style/ClassAndModuleChildren
    IGNORED_MODEL_NAMES = ["ActiveStorage::Attachment"]
    alias unfiltered_desired_indexes desired_indexes

    def desired_indexes(model)
      indexes = unfiltered_desired_indexes(model)
      indexes.reject { |index| IGNORED_MODEL_NAMES.include?(index.model.name) }
    end
  end
end
