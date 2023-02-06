module Account
  class StableDescriptionContract < Dry::Validation::Contract
    params do
      required(:description).filled(:string)
    end
  end
end

