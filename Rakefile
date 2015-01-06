require 'rubygems'
require 'bundler/setup'

task :test do
  require 'simplecov'
  require 'test/unit'
  SimpleCov.start
  Test::Unit::AutoRunner.run(true, 'test')
end

task default: [:test]