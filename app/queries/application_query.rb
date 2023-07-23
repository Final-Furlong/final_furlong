class ApplicationQuery
  include ActiveModel::Model

  # Set up accessors with validations in a single step.
  def self.property(name, options = {})
    attr_accessor name

    validates(name, options[:validates]) if options.key?(:validates)
  end

  attr_reader :context

  def initialize(context, attributes = {})
    @context = context
    assign_attributes(attributes)
    raise "Authorization failed" unless authorized?
  end

  # Let's make it easy to access values in the context.
  def method_missing(name, *args)
    name_symbol = name.to_sym
    context.key?(name_symbol) ? context[name_symbol] : super
  end

  def respond_to_missing?(name, *args)
    context.key?(name.to_sym) || super
  end

  private

    def authorized?
      raise 'Please implement the "authorized?" method in the query class.'
    end
end

