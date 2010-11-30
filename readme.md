# Refinery CMS Blog - Rails 2 branch

Simple blog engine for [Refinery CMS](http://refinerycms.com). It supports posts, categories and comments.

Refinery CMS Blog supports Rails 3 on the [master branch](http://github.com/resolve/refinerycms-blog).

Options:

* Comment moderation
* [ShareThis.com](http://sharethis.com) support on posts. Set your key in Refinery's settings area to enable this.

## Install

Open up your ``Gemfile`` and add at the bottom this line

    gem 'refinerycms-blog', '= 1.0.rc16'

Please note 1.0.rc16 is the last version of Refinery CMS Blog to support Rails 2.

Now run ``bundle install``

Next to install the blog plugin run (for Rails 2):

    ruby script/generate refinerycms_blog

Finally migrate your database and you're done.

    rake db:migrate
