module Account
  def stable
    Dry::Schema.Params do
      required(:description).value(:string)
    end
  end
end
