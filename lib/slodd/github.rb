# encoding: utf-8
require "open-uri"

module Slodd
  class Github
    attr_accessor :owner, :repo, :path, :token, :ref

    def initialize(attrs)
      self.owner = attrs.fetch(:owner)
      self.repo  = attrs.fetch(:repo)
      self.token = attrs.fetch(:token)
      self.path  = attrs.fetch(:path)
      self.ref   = attrs[:ref]
    end

    def schema
      @schema ||= open(url, headers).read
    rescue OpenURI::HTTPError
      raise Slodd::GithubError, "Check your credentials and the schema file location!"
    end

    private

    def url
      "https://api.github.com/repos/#{owner}/#{repo}/contents/#{path}#{branch}"
    end

    def branch
      "?ref=#{ref}" unless ref.nil?
    end

    def headers
      {
        "Accept" => "application/vnd.github.3.raw",
        "Authorization" => "token #{token}",
      }
    end
  end
end
