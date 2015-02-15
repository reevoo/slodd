# encoding: utf-8
require 'active_support/core_ext/module/attribute_accessors'

module Slodd
  module Config
    mattr_accessor :path, :github, :username, :password,
                   :host, :url, :token, :ref
    mattr_writer :databases

    def self.defaults
      self.path = 'db/schema.rb'
      self.username = 'root'
      self.host = 'localhost'
      self.databases = nil
    end

    defaults

    def self.databases
      @@databases ? @@databases.split : []
    end

    def self.database_settings
      settings = { adapter: 'mysql2', host: host, username: username }
      password ? settings.merge(password: password) : settings
    end

    def self.owner
      github.split('/')[0] if github
    end

    def self.repo
      github.split('/')[1] if github
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
  end
end
