require 'pry'
module Authentications

  class UpdateAuthentication

    def initialize(user_id:)
      # rubocop:disable Lint/Debugger
      #binding.pry
      @user_id = user_id
    end

    def set_id()
      last_auth_id = Authentication.order(Sequel.desc(:id)).limit(1).first.id
      last_auth_record = Authentication[last_auth_id]
      last_auth_record.update(user_id: @user_id)
    end

  end

end