DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/db/datastore.sqlite3")

class Post
  include DataMapper::Resource

  property :id, Serial
  property :title, String
  property :slug, String
  property :file_name, String, :required => true
  property :created_at, DateTime

  has n, :categorizations
  has n, :categories, :through => :categorizations
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
