require "#{File.dirname(__FILE__)}/spec_helper"

describe 'Post' do
  describe ".create_from_raw" do
    before do
      haml_file = <<HAML
%h1
  The delete_if method
%span.date
  08-05-2010
%span.categories
  ruby
.content
  .snippet
    I just discovered the Array's delete_if method. Its extremely nifty and I tought I'd share it here.
  .main
    This is an example of the use of the delete_if method. As the name suggests it is used to delete certain elements of an array if they satisfy certain conditions. For example if I wanted to get a list of all elements in a directory without . and .. , I could use this:
    %pre{:name => "code", :class => "ruby"}
      Dir.entries('directory').delete_if {|i| i=~ /^\.*$/}
HAML
      File.open('tempfile.haml','w') {|f| f.write(haml_file)}
      Post.create_from_raw(:filename => 'tempfile.haml', :tempfile => File.open('tempfile.haml','r'))
    end
    after do
      FileUtils.rm('tempfile.haml')
    end
    it "should create a fully populated post" do
      Post.last.title.should == "The delete_if method"
    end
    it "should populate content correctly" do
      Post.last.content.should == "\n  <div class=\"snippet\">\n    I just discovered the Array's delete_if method. Its extremely nifty and I tought I'd share it here.\n  </div>\n  <div class=\"main\">\n    This is an example of the use of the delete_if method. As the name suggests it is used to delete certain elements of an array if they satisfy certain conditions. For example if I wanted to get a list of all elements in a directory without . and .. , I could use this:\n    <pre class=\"ruby\" name=\"code\">Dir.entries('directory').delete_if {|i| i=~ /^.*$/}</pre>\n  </div>\n"
    end
  end

  describe ".get_by_slug_or_id" do
    before do
      @post= Post.create(:title => 'temp', :slug => 'temp')
    end
    it "should retreive a post if an id is given" do
      Post.get_by_slug_or_id(@post.id).should == @post
    end
    it "should retreive a post if a slug is given" do
      Post.get_by_slug_or_id('temp').should == @post
    end
  end
end

