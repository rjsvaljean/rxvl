Feature: Adding a post
  In order to check that post adding works
  As a contributor
  I want to write a post
  And run the Post.update
  And see it on the home page

  Scenario: Create a post
    Given I have added a new post haml file
    And I have run Post.update
    And I visit the "home" page
    Then I should see the last 1 posts
