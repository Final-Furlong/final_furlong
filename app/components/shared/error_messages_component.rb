# typed: true

class Shared::ErrorMessagesComponent < ViewComponent::Base
  def initialize(object:)
    super()
    @object = object
  end
end
