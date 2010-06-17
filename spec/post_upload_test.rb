require "application"

title= (1..10).collect{('a'..'z').collect[rand(25)]}.join
haml_doc="%h1
  #{title}
%span.date
  08-05-2010
%span.categories
  ruby
.content
  .snippet
    I just discovered the Array's delete_if method. Its extremely nifty and I tought I'd share it here.
  .main
    This is an example of the use of the delete_if method. As the name suggests it is used to delete certain elements of an array if they satisfy certain conditions. For example if I wanted to get a list of all elements in a directory without . and .. , I could use this:
    %pre{:name => \"code\", :class => \"ruby\"}
      Dir.entries('directory').delete_if {|i| i=~ /^\.*$/}"
File.open('blhablha.haml','w') {|f| f.write(haml_doc)}
`curl -F data=@blhablha.haml http://localhost:4567/post > temp`
FileUtils.rm('blhablha.haml')
puts 'passed' if Post.last.title == title
