class Post

  before :save, :create_slug
  before :save, :set_created_at 

  def date
    created_at.strftime("%d %b") if created_at
  end

  def full_file_name
    File.join(APP_ROOT, 'posts', file_name)
  end

  def hpricot_doc
    haml= File.read(full_file_name)
    html= Hpricot(Haml::Engine.new(haml).render)
  end

  def content
    (hpricot_doc/'p[@class="content"]').inner_html
  end

  def snippet
    (hpricot_doc/'div[@class="snippet"]').inner_html
  end

  def create_slug
    self.slug= file_name[3..-6]
  end
  
  def permalink
    "#{BLOG_BASE}/post/#{file_name[3..-6]}"
  end
  
  def set_created_at
    begin
      date= Date.parse((hpricot_doc/'span[@class="date"]').inner_html.strip)
    rescue
      date= nil
    end
    self.created_at= date || Time.now
  end

  def self.get_title(file_name)
    haml= File.read("posts/#{file_name}")
    html= Haml::Engine.new(haml).render
    hpricot_doc= Hpricot(html)
    title= (hpricot_doc/'h1').inner_html
    if title == "" || title == nil
      title= file_name[3..-6].split('-').join(' ').capitalize
    end
    title.strip
  end

  def file_created_at
    Date.parse((hpricot_doc/'span[@class="date"]').inner_html.strip)
  end

  def file_categories
    (hpricot_doc/'span[@class="categories"]').inner_html.strip.split(/,\ */).collect{|cat| Category.create_or_find(cat)}
  end

  def file_slug
    file_name[3..-6]
  end

  def self.update(post_id = nil)
    posts= (Dir.entries('posts').delete_if {|i| i=~ /^\..*$/}).sort
    if post_id
      file_name= posts.select{|i| i=~ /#{post_id}-/}
      if file_name.empty?
        raise NameError
      elsif file_name.length > 1
        puts "Ambiguity between these posts:\n #{file_name.join("\n* ")}"
      else
        file_name= file_name[0]
        post= Post.all(:file_name => file_name)[0]
        post.update(:title => get_title(file_name), 
                    :created_at => post.file_created_at,
                    :slug => post.file_slug,
                    :categories => post.file_categories)
      end
    else
      if Post.last
        unless posts.last == Post.last.file_name
          new_post= Post.new(:title => get_title(posts.last),
                              :file_name => posts.last)
          new_post.save
        end
      else
        posts.each do |post|
          new_post= Post.new(:title => get_title(post),
                              :file_name => post)
          new_post.save
        end
      end
    end
  end
end
