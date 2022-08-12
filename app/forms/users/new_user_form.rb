module Users
  class NewUserForm < ApplicationForm
    include FinalFurlong::Internet::Validation

    attr_accessor :user, :stable, :name, :email, :password, :password_confirmation, :stable_name, :username, :params

    validates :name, :email, :username, :password, :password_confirmation, :stable_name, presence: true
    validates :email, email: true
    validates :username, length: { minimum: User::USERNAME_LENGTH }
    validates :password, length: { minimum: User::PASSWORD_LENGTH }
    validates_email :email
    validates_password :password
    validate :validate_unique_email
    validate :validate_unique_username

    delegate :persisted?, to: :user

    def initialize(user)
      @user = user
      super()
    end

    def submit(params) # rubocop:disable Metrics/MethodLength
      @params = params
      assign_attributes(params)
      return false if invalid?

      user.assign_attributes(user_params)
      stable.assign_attributes(stable_params)
      User.transaction do
        user.save!
        stable.save!
      end
    rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
      false
    end

    private

      def stable_params
        { name: params[:stable_name] }
      end

      def user_params
        params.except(:stable_name)
      end

      def initial_attributes
        assign_attributes(@user.attributes.slice(:email, :name, :password, :password_confirmation, :username, :status))
        @stable = @user.stable || @user.build_stable
      end

      def validate_unique_email
        return unless email

        errors.add(:email, :taken) if User.exists?(["LOWER(email) = ?", email.downcase])
      end

      def validate_unique_username
        return unless username

        errors.add(:username, :taken) if User.exists?(["LOWER(username) = ?", username.downcase])
      end
  end
end

