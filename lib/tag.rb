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

  def linked_tag_name
    "<a href='#{link}'>#{name}</a>"
  end
end

class PostTag
  include DataMapper::Resource

  property  :id,    Serial
 
  belongs_to :post
  belongs_to :tag
end
