require 'nokogiri'
require 'tilt'
require 'rdiscount'

class Post
  include DataMapper::Resource

  property  :id,          Serial
  property  :title,       String,    :required => true  
  property  :slug,        String,    :required => true, :unique => true  
  property  :snippet,     Text
  property  :content,     Text
  property  :created_at,  DateTime
  property  :updated_at,  DateTime

  has n,    :comments
  has n,    :post_tags
  has n,    :tags, :through => :post_tags

  validates_presence_of :title

  def self.create_from_raw(file, filename)
    FileUtils.mv(file.path,file.path+File.extname(filename))
    begin
      html_doc= HTMLParser.new(Tilt.new(file.path+File.extname(filename)).render)
      post= Post.new(html_doc.params)
      post.save ? true : post.errors
    rescue => e
      [e]
    end
  end

  def update_from_raw(file, filename)
    FileUtils.mv(file.path,file.path+File.extname(filename))
    begin
      html_doc= HTMLParser.new(Tilt.new(file.path+File.extname(filename)).render)
      self.update(html_doc.params) ? true : self.errors
    rescue => e
      [e]
    end
  end

  def self.get_by_slug_or_id(id)
    id.to_i == 0 ? Post.first(:slug => id) : Post.get(id.to_i)
  end

  def created_at_date
    created_at.strftime('%d %b \'%y')
  end
end

class HTMLParser

  attr_reader :params

  def initialize(html)
    @html_doc= Nokogiri::HTML(html)
    @params = {
      :title    => title,
      :slug     => create_slug,
      :snippet  => @html_doc.at_css('.snippet').inner_html,
      :content  => @html_doc.at_css('.content').inner_html,
      :created_at =>  @html_doc.at_css('span.date').content.strip,
      :tags     => create_if_necessary_and_list_tags(@html_doc.at_css('span.categories').content.strip) }
  end

  def create_slug
    title.downcase.gsub(/\W/,'-').gsub(/[-]+/,'-').gsub(/^-|-$/,'')[0..49]
  end

  def title
    @title ||= @html_doc.at_xpath('//h1').content.strip
  end

  def create_if_necessary_and_list_tags(string)
    tags= string.split(',').collect{|i| i.strip}
    tags.collect do |t|
      slug= t.downcase.gsub(' ', '-')
      tag= Tag.create(:name => t, :slug => slug) unless tag= Tag.first(:slug => slug)
      tag
    end
  end
end
