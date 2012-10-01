require File.expand_path("../lib/letters/version", __FILE__)

Gem::Specification.new do |s|
  s.specification_version = 3 if s.respond_to? :specification_version
  s.required_rubygems_version = ">= 1.3.6"
  
  s.name      = "letters"
  s.version   = Letters::VERSION
  
  s.platform  = Gem::Platform::RUBY
  s.homepage  = "http://lettersrb.com"
  s.author    = "David Jacobs"
  s.email     = "david@wit.io"
  s.summary   = "A tiny debugging library for Ruby"
  s.description = "Letters brings Ruby debugging into the 21st century. It leverages print, the debugger, control transfer, even computer beeps to let you see into your code's state."

  s.files = Dir["lib/**/*"] + [
    "README.md",
    "COPYING",
    "Gemfile"
  ]

  s.test_files = Dir["spec/**/*"]

  s.require_path = "lib"

  s.add_dependency "awesome_print"
  s.add_dependency "activesupport"
  s.add_dependency "xml-simple"
  s.add_dependency "colorize"
  s.add_dependency "debugger"

  s.add_development_dependency "timecop"
  s.add_development_dependency "rspec"
end
