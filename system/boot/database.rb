# frozen_string_literal: true
require 'pry'
# This file contain code to setup the database connection.

Application.boot(:database) do |container|
  # Load environment variables before setting up database connection.
  use :environment_variables

  init do
    require 'sequel/core'
  end

  start do
    # Delete DATABASE_URL from the environment, so it isn't accidently passed to subprocesses.
    database = Sequel.connect('postgres:///authentication-development')
    #DB = Sequel.connect(adapter: 'postgres', host: '/var/run/postgresql', database: 'authentication-development', user: 'postgres', password: 'mynewpassword2')

    # Register database component.
    container.register(:database, database)
  end
end
