module CurrentStable
  class BaseController < AuthenticatedController
    def authorized(scope, policy_scope_class = nil)
      if policy_scope_class
        super([:current_stable, scope], with: policy_scope_class)
      else
        super([:current_stable, scope])
      end
    end

    def authorize(record, query = nil)
      super([:current_stable, record], query)
    end
  end
end

