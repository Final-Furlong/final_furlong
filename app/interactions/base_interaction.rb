require "active_interaction"

class BaseInteraction < ActiveInteraction::Base
  def execute
    raise NotImplementedError, "#execute must be defined in #{self.class}"
  end
end
