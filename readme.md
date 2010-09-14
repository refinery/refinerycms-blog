# About

Basic blog plugin for Refinery CMS. It supports posts, categories and comments (with the option of moderation).

# Install

Open up your ``Gemfile`` and add at the bottom this line

    gem 'refinerycms-blog', '= 1.0.rc9'

Now run ``bundle install``

Next to install the blog plugin run:

    ruby script/generate refinery_blog

Finally migrate your database and you're done.

    rake db:migrate