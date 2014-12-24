$:.unshift(File.expand_path(File.dirname(__FILE__)+"/lib"))
$:.unshift(File.expand_path(File.dirname(__FILE__)))
require 'rake'
require 'rubygems'
require 'rtf'

begin
  require 'simplecov'
  require 'test/unit'
  SimpleCov.start
  Test::Unit::AutoRunner.run(true, 'test')
rescue LoadError
  puts "SimpleCov is not available. In order to run SimpleCov, you must: gem install simplecov"
end
