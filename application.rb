require 'rubygems'
require 'sinatra'
require 'environment'

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
end

error do
  e = request.env['sinatra.error']
  Kernel.puts e.backtrace.join("\n")
  'Application error'
end

helpers do
  # add your helpers here
end

# root page
get '/' do
  @posts= Post.first(5, :order => [:created_at.desc])
  haml :home
end

# read
get '/post/:id' do
  @post= Post.get_by_slug_or_id(params[:id])
  haml :post
end

# create
post '/post' do
  Post.create_from_raw(params[:data][:tempfile])
end

# update
post '/post/:id' do
  Post.get_by_slug_or_id(params[:id]).update(params)
end

# delete
delete '/post/:id' do
  Post.get_by_slug_or_id(params[:id]).destroy
end

get '/tag/:slug' do
  @posts= Tag.first(:slug => params[:slug]).posts(:order => [:created_at.desc])
  haml :home
end
