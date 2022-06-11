module Shared
  class ErrorMessagesComponent < ViewComponent::Base
    def initialize(object:)
      super()
      @object = object
    end
  end
end
