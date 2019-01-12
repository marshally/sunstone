require 'rubygems'

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

Dir.mkdir("tmp") unless Dir.exists?("tmp")
Dir.mkdir("tmp/cache") unless Dir.exists?("tmp/cache")
