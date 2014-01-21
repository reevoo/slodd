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
        eval(schema)
      end
    end

    private
    def create_database(database)
      puts "create_database(#{database})"
      options = {charset: 'utf8', collation: 'utf8_unicode_ci'}

      begin
        ActiveRecord::Base.establish_connection database_settings
        ActiveRecord::Base.connection.drop_database database
        ActiveRecord::Base.connection.create_database database, options
        ActiveRecord::Base.establish_connection database_settings.merge(database: database)
      rescue Mysql2::Error => sqlerr
        $stderr.puts sqlerr.error
        $stderr.puts "Couldn't create database: #{database} settings: #{database_settings.inspect}, charset: utf8, collation: utf8_unicode_ci"
      end
    end

    def database_settings
      Config.database_settings
    end

    attr_accessor :schema
  end
end
