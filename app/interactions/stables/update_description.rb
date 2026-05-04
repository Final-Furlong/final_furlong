module Stables
  class UpdateDescription < BaseInteraction
    include ActionView::Helpers::SanitizeHelper

    object :stable, class: Account::Stable

    string :description, default: nil

    validates :description, length: { maximum: 1000 }

    def execute
      update_stables

      stable
    end

    private

    def update_stables
      Account::Stable.transaction do
        stable.description = new_stable_description

        if !stable.save!
          errors.merge!(stable.errors)
        end
      end
    end

    def new_stable_description
      sanitize(description, tags: %w[strong em u br])
    end
  end
end

