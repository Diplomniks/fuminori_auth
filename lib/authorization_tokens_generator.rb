# frozen_string_literal: true

# {AuthorizationTokensGenerator} generates access and refresh token for {User}.
class AuthorizationTokensGenerator
  def initialize(auth:)
    @auth = auth
  end

  # It generates access and refresh token for specified {User}.
  #
  # @return [Hash] that contains informations about access and refresh token for {User}.
  #
  # @example Generate access and refresh token for {User}:
  #   AuthorizationTokensGenerator.new(user: User.last).call
  def call
    {
      access_token: { token: access_token, expires_in: 300 },
      refresh_token: { token: refresh_token, expires_in: 900 }
    }
  end

  private

  # It generates access token for specified {User}.
  #
  # @see AccessTokenGenerator
  #
  # @return [String] Access token for specified {User}.
  def access_token
    # rubocop:disable Lint/Debugger
    #binding.pry
    AccessTokenGenerator.new(auth: @auth).call
  end

  # It generates refresh token for specified {User}.
  #
  # @see RefreshTokenGenerator
  #
  # @return [String] Refresh token for specified {User}.
  def refresh_token
    RefreshTokenGenerator.new(auth: @auth).call
  end
end
