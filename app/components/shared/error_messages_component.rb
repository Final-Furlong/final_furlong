module Shared
  class ErrorMessagesComponent < ApplicationComponent
    def initialize(object:)
      super()
      @object = object
    end
  end
end

