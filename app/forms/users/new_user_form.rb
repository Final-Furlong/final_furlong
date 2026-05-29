module Users
  class NewUserForm < ApplicationForm
    include FinalFurlong::Internet::Validation

    attr_accessor :name, :email, :stable_name, :username, :params

    validates :stable_name, presence: true

    before_validation :set_stable_name

    def initialize(attributes)
      super
      @models = [user, stable]
    end

    private

    def set_stable_name
      stable.name = stable_name
    end

    def user
      @user ||= Account::User.new(
        name:,
        email:,
        username:
      )
    end

    def stable
      @stable ||= Account::Stable.new(name: stable_name, user:)
    end
  end
end

