Feature: Home Page
  In order to check that the Home Page is showing what its supposed to
  As a visitor
  I want to see the 5 latest posts and link to the post page

  Scenario: Visit home page
    Given I visit the "home" page
    Then I should see the last 5 posts
  Scenario: Clicking on posts in the home page
    Given I visit the "home" page
    When I follow the first post link
    Then I should see the last 1 post
