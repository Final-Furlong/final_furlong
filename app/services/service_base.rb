module ServiceBase
  def call(**args, &)
    new.call(**args, &)
  end

  def call!(**args, &)
    result = call(**args, &)

    raise result.error unless result.success?

    result
  end
end

