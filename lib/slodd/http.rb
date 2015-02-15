# encoding: utf-8
require 'open-uri'

module Slodd
  class Http
    attr_accessor :url

    def initialize(attrs)
      self.url = attrs.fetch(:url)
    end

    def schema
      open(url).read
    end
  end
end
