module Sluggable
  extend ActiveSupport::Concern

  def to_param
    if invalid? && slug_changed?
      # return original slug value
      changes["slug"].first
    else
      slug
    end
  end
end
