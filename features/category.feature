@blog @blog_categories
Feature: Blog Post Categories
  Blog posts can be assigned categories
  
  Background:
    Given I am a logged in refinery user
    Given there is a category titled "Videos"
  
  Scenario: The blog post new/edit form has category_list
    When I am on the new blog post form
    Then I should see "Tags"
    Then I should see "Videos"
    
  Scenario: The blog post new/edit form saves categories
    When I am on the new blog post form
    And I fill in "Title" with "This is my blog post"
    And I fill in "blog_post_body" with "And I love it"
    And I check "Videos"
    And I press "Save"

    Then there should be 1 blog post
    And the blog post should have 1 category
    And the blog post should have the category "Videos"