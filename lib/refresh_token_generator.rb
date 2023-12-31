# frozen_string_literal: true

# {RefreshTokenGenerator} generates refresh token for {User}.
class RefreshTokenGenerator
  # @param [User] user
  def initialize(auth:)
    @auth = auth
  end

  # It generates refresh token for {User}.
  #
  # @return [String] refresh token which is valid for 15 minutes.
  #
  # @example Generate refresh token for {User}:
  #   Users::RefreshTokenGenerator.new(user: User.last).call
  def call
    data = { auth_id: @auth.id, authentication_token: @auth.authentication_token }

    MessageVerifier.encode(data: data, expires_at: Time.now + 900, purpose: :refresh_token)
  end
end# frozen_string_literal: true

