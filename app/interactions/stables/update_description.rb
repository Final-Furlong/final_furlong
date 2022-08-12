module Stables
  class UpdateDescription < BaseInteraction
    include ActionView::Helpers::SanitizeHelper

    object :stable

    string :description, default: nil

    validates :description, length: { maximum: 1000 }

    def execute
      update_stables

      stable
    end

    private

      def update_stables
        Stable.transaction do
          stable.description = new_stable_description

          if !stable.save! || !legacy_stable&.update!("Description" => legacy_stable_description)
            errors.merge!(stable.errors)
          end
        end
      end

      def legacy_stable
        LegacyUser.find_by(id: stable.legacy_id)
      end

      def new_stable_description
        sanitize(description, tags: %w[strong em u br])
      end

      def legacy_stable_description
        sanitize(description, tags: [])
      end
  end
end
