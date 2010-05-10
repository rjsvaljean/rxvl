require 'sinatra'
require 'blog.rb'

root_dir= File.dirname(__FILE__)
ENV['RACK_ENV'] ||= 'development'
set :environment, ENV['RACK_ENV'].to_sym
set :root, root_dir
disable :run

run Sinatra::Application
