# encoding: utf-8
require "active_record"
require "mysql2"

module Slodd
  class Runner
    def self.run!
      new.run!
    end

    def initialize
      self.schema = Config.fetcher.schema
    end

    def run!
      Config.databases.each do |database|
        create_database(database)
        eval(schema) # rubocop:disable Lint/Eval
      end
    end

    private

    def create_database(database)
      puts "create_database(#{database})"

      begin
        ActiveRecord::Base.establish_connection database_settings
        ActiveRecord::Base.connection.drop_database database
        ActiveRecord::Base.connection.create_database database, options
        ActiveRecord::Base.establish_connection database_settings(database)
      rescue Mysql2::Error => sqlerr
        error_message(sqlerr, database)
      end
    end

    def database_settings(database = nil)
      Config.database_settings.merge(database: database)
    end

    def options
      { charset: "utf8", collation: "utf8_unicode_ci" }
    end

    def error_message(sqlerr, database)
      $stderr.puts sqlerr.error
      settings = database_settings(database).merge(options).inspect
      $stderr.puts "Couldn't create database with settings: #{settings}"
    end

    attr_accessor :schema
  end
end
