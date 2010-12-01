# Refinery CMS Blog

Simple blog engine for [Refinery CMS](http://refinerycms.com). It supports posts, categories and comments.

Refinery CMS Blog supports Rails 2.3.x using the [Rails 2.3.x stable branch](http://github.com/resolve/refinerycms-blog/tree/rails2-stable).

Options:

* Comment moderation
* [ShareThis.com](http://sharethis.com) support on posts. Set your key in Refinery's settings area to enable this.

## Install

Open up your ``Gemfile`` and add at the bottom this line

    gem 'refinerycms-blog', '~> 1.0.rc.17'

Now run ``bundle install``

Next to install the blog plugin run:

    rails generate refinerycms_blog

Finally migrate your database and you're done.

    rake db:migrate