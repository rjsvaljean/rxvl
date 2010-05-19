require 'sinatra'
require 'haml'
require 'sinatra/respond_to'
require 'blog.rb'

log = File.new("log/sinatra.log", "w")
STDOUT.reopen(log)
STDERR.reopen(log)

root_dir= File.dirname(__FILE__)
ENV['RACK_ENV'] ||= 'development'
set :environment, ENV['RACK_ENV'].to_sym
set :root, root_dir
disable :run

run Sinatra::Application
