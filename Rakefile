require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "reevoocop/rake_task"

ReevooCop::RakeTask.new(:reevoocop)
RSpec::Core::RakeTask.new(:spec)

task default: [:spec, :reevoocop]
