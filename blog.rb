APP_ROOT= File.dirname(__FILE__) 
BLOG_BASE= "http://rjsvaljean.heroku.com"

require 'json'
require 'models/base.rb'

get '/' do
  @posts= Post.first(5, :order => [:created_at.desc])
  @extra_title= "Home"
  haml :home
end

get '/post/:slug' do |slug|
  @post= Post.all(:slug => slug)[0]
  if @post
    @extra_title= @post.title
    haml :post
  else
    haml :not_found
  end
end

get '/posts' do
  content_type :json
  Post.list_files.to_json
end
post '/post/update/:password/:id' do |password,id|
  if password == "openup"
    if id == "all"
      Post.update
      haml :update_successful
    elsif Post.include?(id)
      Post.update(id.to_i)
      haml :update_successful
    else
      haml :not_found
    end
  else
    haml :not_found
  end
end
get '/projects' do
  @extra_title = "Projects"
  haml :projects
end

get '/about' do
  @extra_title = "About Me"
  haml :about
end

get '/archive' do
  @extra_title= "Archive"
  @categories= Category.all
  haml :archive
end

get '/pics' do
  @extra_title= "Photographs"
  haml :pics
end

get '/feed.xml' do
  @posts= Post.all
  builder :feed
end

get '/category/:name' do |name|
  @extra_title= "Category: #{name}"
  @category= Category.all(:name => name)
  if @category.empty?
    haml :not_found
  else
    @posts= @category.first.posts
    haml :home
  end
end

not_found do
  haml :not_found
end
