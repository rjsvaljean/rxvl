require 'rest_client'
require 'json'
load File.join(File.dirname(__FILE__), '..', 'blog.rb')

puts "Enter operation:"
puts "1. List remote post files"
puts "2. Update Post"

choice= gets.to_i

case choice
when 1
  remote_post_files
when 2
  update
end

def remote_post_files
  puts JSON.parse(RestClient.get("#{BLOG_BASE}/posts"))
end
