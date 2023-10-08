class Authentication < Sequel::Model
  plugin :secure_password, include_validations: false

  def validate
    super
    # rubocop:disable Lint/Debugger
    # binding.pry
    validates_format(Constants::EMAIL_REGEX, :email) if email
  end
end