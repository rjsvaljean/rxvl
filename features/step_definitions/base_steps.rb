Given /^I visit the "(.*)" page$/ do |page|
  if page == "home"
    visit '/'
  end
end

Given /^I have added a new post haml file*/ do
  File.open('posts/99-test-post.haml','w') do |file|
    file.write("%h1
  This is a test
%span.date
  #{Time.now.strftime('%d-%m-%Y')}
%span.categories
  test
%p.content
  .snippet
    This is a test.
  .main
    Further testing")
  end
end

Given /^I have run Post.update$/ do
  Post.update
end

When /^I follow the first post link$/ do
  click_link Post.first(:order => [:created_at.desc]).title
end

Then /^I should see the last (.*) post(.*)$/ do |n, collection|
  if collection == "s"
    Post.first(n.to_i, :order => [:created_at.desc]).each do |post|
      response_body.should =~ /#{Regexp.escape(post.title)}/
    end
  else
    response_body.should have_selector("h3.post_title", :content => Post.first(:order => [:created_at.desc]).title)
  end
end
