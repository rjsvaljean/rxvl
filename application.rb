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
  def post_permalink(slug)
    "#{SiteConfig.url_base}post/#{slug}"
  end 
end

# root page
get '/' do
  @posts= Post.first(5, :order => [:created_at.desc])
  haml :home
end

get '/posts.xml' do
  @posts= Post.all(:order => [:created_at.desc])
  builder do |xml|
    xml.instruct! :xml, :version => '1.0'
    xml.rss :version => "2.0" do
      xml.channel do
        xml.title "rxvl"
        xml.description "Ratan Sebastian's posts"
        xml.link "http://rxvl.in"

        @posts.each do |post|
          xml.item do
            xml.title post.title
            xml.link post_permalink(post.slug)
            xml.description post.content
            xml.pubDate Time.parse(post.created_at.to_s).rfc822()
            xml.guid post_permalink(post.slug)
          end
        end
      end
    end
  end
end

get '/archive' do
  @posts= Post.all(:order => [:created_at.desc])
  haml :archive
end

# read
get '/post/:id' do
  @post= Post.get_by_slug_or_id(params[:id])
  @title= @post.title
  haml :post
end

# create
post '/posts' do
  format_output(Post.create_from_raw(params[:data][:tempfile], 
                                     params[:data][:filename]))
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
