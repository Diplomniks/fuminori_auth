# frozen_string_literal: true

module Authentications
  # {Users::Authenticator} checks {User} email and password during authentication process.
  class Authenticator
    # @param [String] email
    # @param [String] password
    def initialize(email:, password:)
      @email    = email
      @password = password
    end

    # It checks if user email and password are correct.
    #
    # @return [User] when email and password are valid.
    #
    # @raise [Exceptions::InvalidEmailOrPassword] when email or password is invalid.
    #
    # @example When email or password is invalid:
    #   Users::Authenticator.new(email: "invalid-email", password: "invalid-password").call
    #
    # @example When email or password are valid:
    #   Users::Authenticator.new(email: "user@example.com", password: "password").call
    def call
      # rubocop:disable Lint/Debugger
      binding.pry
      auth = Authentication.find(email: @email)

      return auth if auth&.authenticate(@password)

      raise(Exceptions::InvalidEmailOrPassword)
    end
  end
end