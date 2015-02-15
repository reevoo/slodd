# encoding: utf-8
require 'simplecov'
SimpleCov.minimum_coverage 100
SimpleCov.start

require 'slodd'
require 'stringio'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end

module Slodd
  module Config
    def self.reset
      defaults
      self.github = nil
      self.password = nil
      self.url = nil
      self.token = nil
      self.ref = nil
    end
  end
end

def capture_stderr
  old_stderr = $stderr
  old_stdout = $stdout
  fake_stderr = StringIO.new
  $stdout = StringIO.new
  $stderr = fake_stderr
  yield
  fake_stderr.string
ensure
  $stdout = old_stdout
  $stderr = old_stderr
end

def capture_stdout
  old_stdout = $stdout
  fake_stdout = StringIO.new
  $stdout = fake_stdout
  yield
  fake_stdout.string
ensure
  $stdout = old_stdout
end

def schema_path
  File.join(File.dirname(__FILE__), 'support', 'schema.rb')
end
