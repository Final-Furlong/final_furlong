# typed: strong

module ITypeAssert
  extend T::Sig
  extend T::Generic

  abstract!
end

module TypeAssertImpl; end

class TA
  extend T::Sig
  extend T::Generic
  include ITypeAssert
  extend TypeAssertImpl
end
