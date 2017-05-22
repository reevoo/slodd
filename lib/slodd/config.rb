# encoding: utf-8
require "active_support/core_ext/module/attribute_accessors"
require "uri"

module Slodd
  module Config
    mattr_accessor :path, :github, :username, :password,
      :host, :url, :token, :ref
    mattr_writer :databases

    def self.defaults
      self.path = "db/schema.rb"
      self.username = "root"
      self.host = "localhost"
      self.databases = nil
    end

    defaults

    def self.databases
      self.databases = database_uri.path[1..-1] if database_uri
      @@databases ? @@databases.split : []
    end

    def self.database_settings
      settings_from_url || settings_from_args
    end

    def self.owner
      github.split("/")[0] if github
    end

    def self.repo
      github.split("/")[1] if github
    end

    def self.fetcher
      if github
        validate_github
        Github.new(attributes)
      elsif url
        Http.new(attributes)
      elsif path
        Local.new(attributes)
      end
    end

    def self.validate_github
      fail ArgumentError unless owner && repo && token
    end

    def self.attributes
      {
        owner: owner,
        repo: repo,
        token: token,
        path: path,
        ref: ref,
        url: url,
      }.delete_if { |_, v| v.nil? }
    end

    private

    def self.settings_from_url
      return unless database_uri
      self.databases = database_uri.path[1..-1]
      {
        adapter: database_uri.scheme,
        host: database_uri.host,
        username: database_uri.user,
        password: database_uri.password,
      }
    end

    def self.database_uri
      return unless ENV["DATABASE_URL"]
      @_database_uri ||= URI.parse(ENV["DATABASE_URL"])
    end

    def self.settings_from_args
      settings = { adapter: "mysql2", host: host, username: username }
      settings.merge!(password: password) if password
      settings
    end
  end
end
