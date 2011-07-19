@blog @blog_editor
Feature: Blog Editor Supports Textile
  Blog post wymeditor can be switched out to a 
  plain textarea with textile processing via a setting
  
  Scenario: use_textile? is false
    Given I am a logged in refinery user
    And the RefinerySetting use_textile_for_blog_posting is false for scoping blog
    
    When I am on the new blog post form
    
    Then there should not be a "RedCloth Textile" link
    And there should be a wymeditor class on the textarea#blog_post_body element
    
  Scenario: use_textile? is true
    Given I am a logged in refinery user
    And the RefinerySetting use_textile_for_blog_posting is true for scoping blog
    
    When I am on the new blog post form
    
    Then there should be a "RedCloth Textile" link
    And there should not be a wymeditor class on the textarea#blog_post_body element
  
  @textile  
  Scenario: Textile input should be processed into html
    Given I am a logged in refinery user
    And the RefinerySetting use_textile_for_blog_posting is true for scoping blog
    
    When I am on the new blog post form
    And I fill in "Title" with "Test Post"
    And I fill in "blog_post_textile_body" with "h1. Foo"
    And I press "Save"
    
    Then there should be 1 blog post
    And the first blog post should have a body field containing "<h1>Foo</h1>"
    And the first blog post should have a textile_body field containing "h1. Foo"
  
  