@blog_tags
Feature: Blog Post Tags
  Blog posts can be assigned tags
  
  Scenario: The blog post new/edit form has tag_list
    Given I am a logged in refinery user
    
    When I am on the new blog post form
    Then I should see "Tags"
    
  Scenario: The blog post new/edit form saves tag_list
    Given I am a logged in refinery user

    When I am on the new blog post form
    And I fill in "Title" with "This is my blog post"
    And I fill in "Body" with "And I love it"
    And I fill in "Tags" with "chicago, bikes, beers, babes"
    And I press "Save"

    Then there should be 1 blog post
    And the blog post should have the tags "chicago, bikes, beers, babes"