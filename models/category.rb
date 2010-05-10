class Category

  def self.create_or_find(cat)
    cats= Category.all(:name => cat)
    unless cats.empty?
      cats.first
    else
      new_cat= Category.new(:name => cat)
      new_cat.save
      new_cat
    end
  end

  def self.add_to_post(post_slug)
    post= Post.all(:slug => post_slug).first
    if post
      categories= (post.hpricot_doc/'span[@class="categories"]').inner_html.strip.split(/,\ */)
      available_categories= Category.all.collect{|i| i.name}
      categories.each do |cat|
        Category.new(:name => cat).save unless avialable_categories.include? cat
        post.categories += Category.all(:name => cat)
        puts "Added Category: #{cat}"
      end
      post.save
    else
      puts "Couldn't find your post please try again"
    end
  end
end
