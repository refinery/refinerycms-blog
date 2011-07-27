@blog @blog_tags
Feature: Blog Post Tags
  Blog posts can be assigned tags
  
  Background:
    Given I am a logged in refinery user
  
  Scenario: The blog post new/edit form has tag_list
    When I am on the new blog post form
    Then I should see "Tags"
    
  Scenario: The blog post new/edit form saves tag_list
    When I am on the new blog post form
    And I fill in "Title" with "This is my blog post"
    And I fill in "blog_post_body_source" with "And I love it"
    And I fill in "Tags" with "chicago, bikes, beers, babes"
    And I press "Save"

    Then there should be 1 blog post
    And the blog post should have the tags "chicago, bikes, beers, babes"
    
  Scenario: The blog has a "tagged" route & view
    Given there is a blog post titled "I love my city" and tagged "chicago"
    When I visit the tagged posts page for "chicago"
    Then I should see "Chicago"
    And I should see "I love my city"