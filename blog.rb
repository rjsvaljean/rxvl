require 'models'


get '/' do
  @posts= Post.first(5)
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

get '/projects' do
  haml :projects
end

get '/about' do
  haml :about
end

get '/archive' do
  @categories= Category.all
  haml :archive
end

get '/feed.xml' do
  @posts= Post.all
  builder :feed
end

get '/category/:name' do |name|
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
