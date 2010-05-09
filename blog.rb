require 'models'


get '/' do
  @posts= Post.first(5)
  @extra_title= "Home"
  haml :home
end

get '/post/:slug' do |slug|
  @post= Post.all(:slug => slug)[0]
  @extra_title= @post.title
  haml :post
end

get '/projects' do
  haml :projects
end

get '/about' do
  haml :about
end
