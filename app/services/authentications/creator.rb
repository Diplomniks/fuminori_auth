# frozen_string_literal: true
require "pry"

module Authentications

  class Creator
    # @param [Hash] attributes of the {User}
    def initialize(attributes:)
      @attributes = attributes
    end

    def call
      # rubocop:disable Lint/Debugger
      #binding.pry
      Authentication.create(
        email: @attributes[:email],
        password: @attributes[:password],
        password_confirmation: @attributes[:password_confirmation],
        phone_number: @attributes[:phone_number],
        login: @attributes[:login],
        authentication_token: authentication_token
      )
    end

    private

    # It generates unique authentication token.
    #
    # @see AuthenticationTokenGenerator
    #
    # @return [String] unique authentication token among all users ({User}).
    def authentication_token
      AuthenticationTokenGenerator.call
    end
  end
end
