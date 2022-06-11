# typed: strong

module ITypeAssert
  extend T::Sig
  extend T::Generic

  Elem = type_member(:out)

  abstract!
end

module TypeAssertImpl; end

class TA
  extend T::Sig
  extend T::Generic
  include ITypeAssert
  extend TypeAssertImpl

  Elem = type_member
end
