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

        if !stable.save! || !update_legacy_description
          errors.merge!(stable.errors)
        end
      end
    end

    def update_legacy_description
      legacy_stable&.update_column("Description", legacy_stable_description) # rubocop:disable Rails/SkipsModelValidations
    end

    def legacy_stable
      Legacy::User.find_by(id: stable.legacy_id)
    end

    def new_stable_description
      sanitize(description, tags: %w[strong em u br])
    end

    def legacy_stable_description
      sanitize(description, tags: [])
    end
  end
end

