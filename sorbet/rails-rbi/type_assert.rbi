# typed: strong

module ITypeAssert
  extend T::Sig
  extend T::Generic

  abstract!

  sig { abstract.params(val: T.untyped).returns(Elem) }
  def assert(val); end
end

module TypeAssertImpl; end

class TA
  extend T::Sig
  extend T::Generic
  include ITypeAssert
  extend TypeAssertImpl

  sig { override.params(val: T.untyped).returns(Elem) }
  def assert(val); end
end
