require "slodd/version"
require "rubygems"
require "active_record"
require "open-uri"
require "mysql2"

module Slodd
  class Base
    def initialize(options)
      @url = options[:url]
      @schema = options[:file]
      @database_settings = {:adapter => "mysql2", :host => "localhost",:username => "root"}.merge options.reject {|key,| [:url,:file].include?(key) } || {}
    end

    def run!
      create_database
      unless @schema
        eval(open(@url){|f| f.read })
      else
        load(@schema)
      end
    end

    private

    def create_database
      options = {:charset => 'utf8', :collation => 'utf8_unicode_ci'}

      create_db = lambda do |config|
        ActiveRecord::Base.establish_connection config.merge(:database => nil)
        ActiveRecord::Base.connection.drop_database config[:database]
        ActiveRecord::Base.connection.create_database config[:database], options
        ActiveRecord::Base.establish_connection config
      end

      begin
        create_db.call @database_settings
      rescue Mysql::Error => sqlerr
        $stderr.puts sqlerr.error
        $stderr.puts "Couldn't create database for #{@database_settings.inspect}, charset: utf8, collation: utf8_unicode_ci"
      end
    end
  end
end
