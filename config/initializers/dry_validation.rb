require "dry/monads/do"
require "dry-validation"

Dry::Validation.load_extensions(:monads)

require_relative "../../app/contracts/all_models"

