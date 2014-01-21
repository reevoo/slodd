# encoding: utf-8
module Slodd
  class Local
    attr_accessor :path

    def initialize(attrs)
      self.path = attrs.fetch(:path)
    end

    def schema
      File.read(path)
    end
  end
end
