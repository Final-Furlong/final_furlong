class VariantComponent < ApplicationComponent
  def initialize(version: nil, variants: [])
    @version = version
    @variants = variants
    super
  end

  private

    attr_reader :version, :variants

    def visible_on_phone?
      raise NotImplementedError, "#{self.class} does not define variants" if variants.blank?

      version_for_phone? && variants.include?(:phone)
    end

    def visible_on_tablet?
      raise NotImplementedError, "#{self.class} does not define variants" if variants.blank?

      version_for_tablet? && variants.include?(:tablet)
    end

    def visible_on_desktop?
      raise NotImplementedError, "#{self.class} does not define variants" if variants.blank?

      version_for_desktop? && variants.include?(:desktop)
    end

    def version_for_phone?
      raise NotImplementedError, "#{self.class} does not define version" if version.blank?

      version == :phone
    end

    def version_for_tablet?
      raise NotImplementedError, "#{self.class} does not define version" if version.blank?

      version == :tablet
    end

    def version_for_desktop?
      raise NotImplementedError, "#{self.class} does not define version" if version.blank?

      version == :desktop || version_for_tablet?
    end
end

