# frozen_string_literal: true

  require 'roda'
  require 'pry'
  require_relative 'system/boot'
  require 'rack/cors'
  require 'http'


  # The main class for Roda Application.
  class App < Roda

    use Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: %i[get post put patch delete options]
      end
    end

    # Adds support for handling different execution environments (development/test/production).
    plugin :environments

    # Adds support for heartbeats.
    plugin :heartbeat

    configure :development, :production do
      # A powerful logger for Roda with a few tricks up it's sleeve.
      plugin :enhanced_logger
    end

    # The symbol_matchers plugin allows you do define custom regexps to use for specific symbols.
    plugin :symbol_matchers

    # Validate UUID format.
    symbol_matcher :uuid, Constants::UUID_REGEX

    # Adds ability to automatically handle errors raised by the application.
    plugin :error_handler do |e|
      # rubocop:disable Lint/Debugger
      binding.pry
      if e.instance_of?(Exceptions::InvalidParamsError)
        error_object    = e.object
        response.status = 422
      elsif e.instance_of?(Sequel::ValidationFailed)
        puts e
        error_object    = e.model.errors
        response.status = 422
      elsif e.instance_of?(Exceptions::InvalidEmailOrPassword)
        error_object    = { error: I18n.t('invalid_email_or_password') }
        response.status = 401
      elsif e.instance_of?(ActiveSupport::MessageVerifier::InvalidSignature)
        error_object    = { error: I18n.t('invalid_authorization_token') }
        response.status = 401
      elsif e.instance_of?(Sequel::NoMatchingRow)
        error_object    = { error: I18n.t('not_found') }
        response.status = 404
      else
        error_object    = { error: e }
        response.status = 500
        puts e
      end

      response.write(error_object.to_json)
    end

    # Allows modifying the default headers for responses.
    plugin :default_headers,
           'Content-Type' => 'application/json',
           'Strict-Transport-Security' => 'max-age=16070400;',
           'X-Frame-Options' => 'deny',
           'X-Content-Type-Options' => 'nosniff',
           'X-XSS-Protection' => '1; mode=block'

    # Adds request routing methods for all http verbs.
    plugin :all_verbs

    # The json_parser plugin parses request bodies in JSON format if the request's content type specifies JSON.
    # This is mostly designed for use with JSON API sites.
    plugin :json_parser

    route do |r|
      r.on('api') do
        r.on('v1') do
          r.post('sign_up') do
            sign_up_params = SignUpParams.new.permit!(r.params)
            auth = Authentications::Creator.new(attributes: sign_up_params).call
            tokens = AuthorizationTokensGenerator.new(auth: auth).call
            AuthSerializer.new(auth: auth, tokens: tokens).render

            # HTTP.post('http://localhost:3000/user', json: sign_up_params)
          end

          r.post('set_id') do
            Authentications::UpdateAuthentication.new(user_id: r.params["user_id"]).set_id
            #AuthSerializer.new(auth: r.params["user_id", tokens: tokens).render
          end

          r.post('login') do
            login_params = LoginParams.new.permit!(r.params)
            auth = Authentications::Authenticator.new(email: login_params[:email], password: login_params[:password]).call
            tokens = AuthorizationTokensGenerator.new(auth: auth).call
            AuthSerializer.new(auth: auth, tokens: tokens).render
          end

        end
      end 
    end
  end

