#!/home/rjsvaljean/dev/ruby/bin/ruby
require 'rubygems'
require 'rest_client'
require 'json'

APP_ROOT= File.join(File.dirname(__FILE__), '..')
BASE_URI= "http://rjsvaljean.heroku.com"
load File.join(APP_ROOT, 'models', 'base.rb')

def remote_post_files
  response= JSON.parse(RestClient.get("#{BASE_URI}/posts").body)
  puts response.keys.collect{|i| "#{response[i] || "*"}. #{i}"}
end

def update
  remote_post_files
  puts "Enter the post to update or press enter to update all"
  choice= gets.to_i
  if choice == 0
    Post.update
  else
    Post.update(choice)
  end
end

def delete
  remote_post_files
  puts "Enter the post id to delete"
  choice= gets.to_i
  Post.get(choice).destroy
end
puts "Enter operation:"
puts "1. List remote post files"
puts "2. Update Post"
puts "3. Delete Post"

choice= gets.to_i

case choice
when 1
  remote_post_files
when 2
  update
when 3
  delete
end

