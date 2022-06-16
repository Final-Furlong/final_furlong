# typed: strict

class ApplicationRecord < ActiveRecord::Base
  include Turbo::Broadcastable::ClassMethods

  primary_abstract_class
end
