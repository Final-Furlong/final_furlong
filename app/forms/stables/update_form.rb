module Stables
  class UpdateForm < ApplicationReformForm
    property :description

    validation do
      required(:description).filled
    end
  end
end
