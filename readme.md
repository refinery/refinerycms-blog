# Refinery CMS Blog - Rails 2 branch

Simple blog engine for [Refinery CMS](http://refinerycms.com).
It supports posts, categories and comments.

Refinery CMS Blog supports Rails 3 on the [master branch](http://github.com/resolve/refinerycms-blog).

Options:

* Comment moderation
* [ShareThis.com](http://sharethis.com) support on posts. Set your key in Refinery's settings area to enable this.

## Requirements

Please note that this requires a RefineryCMS installation between version >= 0.9.7.13
and < 0.9.8 as it works only with the later versions of Rails 2 compatible RefineryCMS.
Also note that any version of this engine 1.1 or greater is not compatible with Rails 2 at all
and is meant for Rails 3 (Refinery CMS >= 0.9.8).

# Install

Open up your ``Gemfile`` and add at the bottom this line:

    gem 'refinerycms-blog', '~> 1.0.1'

Now, run ``bundle install``

Next, to install the blog plugin:

    ruby script/generate refinerycms_blog

Finally migrate your database and you're done.

    rake db:migrate
