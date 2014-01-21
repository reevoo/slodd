require 'simplecov'
SimpleCov.start

require 'slodd'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
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
