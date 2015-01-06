$:.push File.expand_path('../lib', __FILE__)
require 'rtf/version'

Gem::Specification.new do |s|
  s.name = 'rtf'
  s.version = RTF::VERSION
  s.summary = 'Ruby library to create rich text format documents.'
  s.description = 'Ruby RTF is a library that can be used to create rich text format (RTF) documents. RTF is a text based standard for laying out document content.'
  s.email = 'paul@liquidmedia.ca'
  s.homepage = 'http://github.com/landtrustalliance/rtf'
  s.licenses = ["MIT"]
  s.authors = ["Peter Wood", "Claudio Bustos", "Marcello Barnaba", "Dan Arnfield", "Paul Doerwald"]
  s.require_paths = ['lib']
end