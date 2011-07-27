@blog @markup_editor
Feature: Blog Editor Supports alternate markup methods
  Blog post wymeditor can be switched out to another editor or to a textarea with text-based
  markup processing via a setting.
  
  @wymeditor
  Scenario: blog_post_editor is wymeditor
    Given I am a logged in refinery user
    And the RefinerySetting blog_post_editor is wymeditor for scoping blog
    
    When I am on the new blog post form
    
    Then there should be a wymeditor class on the textarea#blog_post_body_source element
    And there should be a wymeditor class on the textarea#blog_post_custom_teaser_source element
  
  @textile
  Scenario: blog_post_editor is textile
    Given I am a logged in refinery user
    And the RefinerySetting blog_post_editor is textile for scoping blog
    
    When I am on the new blog post form
    
    Then there should not be a wymeditor class on the textarea#blog_post_body_source element
    And there should not be a wymeditor class on the textarea#blog_post_custom_teaser_source element
    And there should be a textile class on the textarea#blog_post_body_source element
    And there should be a textile class on the textarea#blog_post_custom_teaser_source element
  
  @textile
  Scenario: Textile input should be processed into html
    Given I am a logged in refinery user
    And the RefinerySetting blog_post_editor is textile for scoping blog
    
    When I am on the new blog post form
    And I fill in "Title" with "Test Post"
    And I fill in "blog_post_body_source" with "h1. Textile Foo"
    And I press "Save"
    
    Then there should be 1 blog post
    And the first blog post should have a body field containing "<h1>Textile Foo</h1>"
    And the first blog post should have a body_source field containing "h1. Textile Foo"
  
  @markdown
  Scenario: Markdown input should be processed into html
    Given I am a logged in refinery user
    And the RefinerySetting blog_post_editor is markdown for scoping blog
  
    When I am on the new blog post form
    And I fill in "Title" with "Test Post"
    And I fill in "blog_post_body_source" with "# Markdown Foo"
    And I press "Save"
  
    Then there should be 1 blog post
    And the first blog post should have a body field containing "<h1>Markdown Foo</h1>"
    And the first blog post should have a body_source field containing "# Markdown Foo"
  
  @wymeditor
  Scenario: HTML input from wymeditor should be left as is
    Given I am a logged in refinery user
    And the RefinerySetting blog_post_editor is wymeditor for scoping blog
    
    When I am on the new blog post form
    And I fill in "Title" with "Test Post"
    And I fill in "blog_post_body_source" with "<h1>HTML Foo</h1>"
    And I press "Save"
    
    Then there should be 1 blog post
    And the first blog post should have a body field containing "<h1>HTML Foo</h1>"
    And the first blog post should have a body_source field containing "<h1>HTML Foo</h1>"
  