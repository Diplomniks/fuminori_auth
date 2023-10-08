# frozen_string_literal: true

# {AccessTokenGenerator} generates access token for {User}.
class AccessTokenGenerator
  def initialize(auth:)
    @auth = auth
  end


  def call
    # rubocop:disable Lint/Debugger
    #binding.pry
    data = { auth_id: @auth.id, authentication_token: @auth.authentication_token }

    MessageVerifier.encode(data: data, expires_at: Time.now + 300, purpose: :access_token)
  end
end