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

get '/archive' do
  @posts= Post.all(:order => [:created_at.desc])
  haml :archive
end

# read
get '/post/:id' do
  @post= Post.get_by_slug_or_id(params[:id])
  haml :post
end

# create
post '/posts' do
  format_output(Post.create_from_raw(params[:data][:tempfile], 
                                      params[:data][:filename])
end

# update
post '/post/:id' do
  @post= Post.get_by_slug_or_id(params[:id])
  if params.has_key?(:data)
    @post.update(params.delete_if{|key, val| key == 'id'})
  else
    format_output(@post.update_from_raw(params[:data][:tempfile], 
                                        params[:data][:filename]))
  end
end

# delete
delete '/post/:id' do
  Post.get_by_slug_or_id(params[:id]).destroy
end

get '/tag/:slug' do
  @posts= Tag.first(:slug => params[:slug]).posts(:order => [:created_at.desc])
  haml :home
end

def format_output(response)
  if response == true
    'Success!'
  else
    'Failure!' + 
    response.to_hash.to_yaml
  end
end
