require 'dm-core'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/datastore.sqlite3")

class Post
  include DataMapper::Resource

  property :id, Serial
  property :title, String, :required => true
  property :slug, String
  property :file_name, String, :required => true
  property :created_at, DateTime

  has n, :comments
  has n, :categorizations
  has n, :categories, :through => :categorizations
end

class Comment
  include DataMapper::Resource

  property :id, Serial
  property :author_name, String
  property :author_email, String
  property :author_url, String
  property :content, Text

  belongs_to :post
end

class Category
  include DataMapper::Resource

  property :id, Serial
  property :name, String

  has n, :categorizations
  has n, :posts, :through => :categorizations
end

class Categorization
  include DataMapper::Resource

  property :id, Serial
  
  belongs_to :category
  belongs_to :post
end
