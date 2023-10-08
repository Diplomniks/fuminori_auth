# frozen_string_literal: true

# {SignUpParams} validates POST /api/v1/sign_up params.
#
# @example When params are valid:
#   SignUpParams.new.permit!(email: "test@user.com", password: "password", password_confirmation: "password_confirmation")
#
# @example When params are invalid:
#   SignUpParams.new.permit!({})
require 'pry'
class SignUpParams < ApplicationParams
  # @!method params
  #   It stores rules for validating POST /api/v1/sign_up endpoint params using dry-validation DSL.
  params do
    # rubocop:disable Lint/Debugger
    #binding.pry
    required(:email).filled(:string).value(format?: Constants::EMAIL_REGEX)
    required(:login).filled(:string)
    required(:password).filled(:string)
    required(:phone_number).filled(:integer)
    required(:birthdate).filled(:date)
    required(:firstName).filled(:string)
    required(:lastName).filled(:string)
  end
end
