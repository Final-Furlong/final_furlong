module Users
  class UpdateUserForm < ApplicationForm
    include FinalFurlong::Internet::Validation

    attr_accessor :user, :username, :email, :name, :stable_name

    validates :name, presence: true
    validates :email, presence: true, email: true
    validates_email :email

    delegate :persisted?, to: :user

    def initialize(user)
      @user = user
      super()
    end

    def submit(params)
      assign_attributes(params)
      return false if invalid?

      user.update!(params)
    rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
      false
    end

    private

      def initial_attributes
        assign_attributes(@user.attributes.symbolize_keys.slice(:username, :email, :name))
        @stable_name = @user.stable.name
      end

      def validate_unique_email
        return unless email

        user_exists = Account::User.where.not(id: user.id).where("LOWER(email) = ?", email.downcase).exists? # rubocop:disable Rails/WhereExists
        errors.add(:email, :taken) if user_exists
      end
  end
end

