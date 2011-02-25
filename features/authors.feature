Feature: Blog Post Authors
  Blog posts can be assigned authors through the given user model
  current_user is assumed through admin screens
  
  Scenario: Saving a blog post in blog_posts#new associates the current_user as the author
    Given there is a user named "hubble"
    And I am logged in as "hubble"
    
    When I am on the new blog post form
    And I fill in "Title" with "This is my blog post"
    And I fill in "Body" with "And I am hubble"
    And I press "Save"
    
    Then there should be 1 blog post
    And the blog post should belong to "hubble"