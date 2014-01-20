require "open-uri"

module Slodd
  class Github
    attr_accessor :owner, :repo, :path, :token, :ref

    def initialize(owner, repo, path, token, ref = nil)
      self.owner = owner
      self.repo  = repo
      self.path  = path
      self.token = token
      self.ref   = ref
    end

    def schema
      @schema ||= open(url, headers).read
    end

    def url
      "https://api.github.com/repos/#{owner}/#{repo}/contents/#{path}#{branch}"
    end

    def branch
      "?ref=#{ref}" if ref.present?
    end

    def headers
      {
        "Accept" => "application/vnd.github.3.raw",
        "Authorization" => "token #{token}",
      }
    end
  end
end
