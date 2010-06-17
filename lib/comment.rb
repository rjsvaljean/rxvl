class Comment
  include DataMapper::Resource

  property :id,           Serial
  property :author,       String
  property :content,      String
  property :created_at,   DateTime
  
  belongs_to :post
end
