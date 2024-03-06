module Users
  class NewUserForm < ApplicationForm
    include FinalFurlong::Internet::Validation

    attr_accessor :name, :email, :password, :password_confirmation, :stable_name, :username, :params

    validates :stable_name, presence: true
    validates_password :password

    before_validation :set_stable_name

    def initialize(attributes)
      super(attributes)
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
        password:,
        password_confirmation:,
        username:
      )
    end

    def stable
      @stable ||= Account::Stable.new(name: stable_name, user:)
    end
  end
end

