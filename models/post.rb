class PostFileMissing
  
end

class Post

  before :save, :create_slug
  before :save, :set_created_at

  def to_hash
    {:title => title,
    :slug => slug,
    :file_name => file_name,
    :created_at => created_at}
  end

  def self.file_exists(file_name)
    Dir.entries(File.join(APP_ROOT, 'posts')).include?(file_name)
  end

  def self.add_new_files
    new_files= self.list_files.delete_if{|i| !Post.all(:file_name => i).empty?}
    new_files.each do |file|
      post= Post.new(:file_name => file)
      post.save
      post.update_from_file
      post
    end
  end

  def self.list_files
    Dir.entries(File.join(APP_ROOT, 'posts')).delete_if{|i| i.match(/^\..*$/)}
  end

  def update_from_file
    update(:title => file_title,
            :created_at => file_created_at,
            :slug => file_slug,
            :categories => file_categories)
  end

  def full_file_name
    File.join(APP_ROOT, 'posts', file_name)
  end

  def hpricot_doc
    @hpricot_doc ||= Hpricot(Haml::Engine.new(File.read(full_file_name)).render)
  end

  def file_title
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

  def date
    created_at.strftime("%d %b") if created_at
  end


  def content
    (hpricot_doc/'p[@class="content"]').inner_html
  end

  def snippet
    (hpricot_doc/'div[@class="snippet"]').inner_html
  end

  def create_slug
    self.slug= /^(\d*)-(.*)\.(\w*)$/.match(file_name)[2]
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
end
