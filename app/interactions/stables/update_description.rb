module Stables
  class UpdateDescription < BaseInteraction
    include ActionView::Helpers::SanitizeHelper

    object :stable

    string :description, default: nil

    validates :description, length: { maximum: 1000 }

    def execute
      stable.description = sanitize(description, tags: %w[strong em u br])

      errors.merge!(stable.errors) unless stable.save

      stable
    end
  end
end
