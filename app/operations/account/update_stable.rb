module Account
  class UpdateStable
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:call)

    def validate(input)
      Account::StableDescriptionContract.new.call(input).to_monad
    end
  end
end

