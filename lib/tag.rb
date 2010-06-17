class Tag
  include DataMapper::Resource

  property  :id,   Serial
  property  :name, String
  property  :slug, String
  
  has n,    :post_tags
  has n,    :posts, :through => :post_tags
  
  def link
    "/tag/#{slug}"
  end
end

class PostTag
  include DataMapper::Resource

  property  :id,    Serial
 
  belongs_to :post
  belongs_to :tag
end
