require 'migrations'
require 'haml'
require 'hpricot'

APP_ROOT= File.dirname(__FILE__) 
BLOG_BASE= "http://rjsvaljean.heroku.com"

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
    self.created_at= Time.now
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
        post.update(:title => get_title(file_name))
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

class Comment
end

class Category
  def self.add_to_post
    puts "Select from the folowing posts: "
    puts Post.all.collect {|i| "#{i.id}. #{i.title} -> #{i.categories.collect(&:name).join(', ')}"}
    post= Post.all(:id => gets.strip.to_i).first
    puts "Select from the available categories(enter comma separated numbers):"
    puts Category.all.collect {|i| "#{i.id}. #{i.name}"}
    puts "*. Add a new category"
    if (input= gets.strip) == "*"
      puts "Enter category name"
      Category.new(:name => gets.strip).save
      puts "Category created. Thank You!"
    else
      categories= (input.split(",").collect{|i| i.strip.to_i}).collect {|i| Category.all(:id => i).first}
      post.categories += categories
      post.save
    end
  end

  def self.remove_from_post
    puts "Select from the folowing posts: "
    puts Post.all.collect {|i| "#{i.id}. #{i.title}"}
    post= Post.all(:id => gets.strip.to_i).first
    puts "Select from the available categories(enter comma separated numbers):"
    puts post.categories.collect {|i| "#{i.id}. #{i.name}"}
    categories= (gets.strip.split(",").collect{|i| i.strip.to_i}).collect {|i| Category.all(:id => i).first}
    post.categories -= categories
    post.save
  end
end
