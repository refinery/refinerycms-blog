# Refinery CMS Blog [![Build Status](https://travis-ci.org/refinery/refinerycms-blog.svg?branch=master)](https://travis-ci.org/refinery/refinerycms-blog)

Simple blog engine for [Refinery CMS](http://refinerycms.com). It supports posts, categories and comments.

This version of `refinerycms-blog` supports Refinery 3.x and Rails 4.1.x.  To use Rails 3.x / Refinery 2.1.x use the [refinerycms-blog "Refinery CMS 2-1 stable branch"](http://github.com/refinery/refinerycms-blog/tree/2-1-stable).

Options:

* Comment moderation
* [ShareThis.com](http://sharethis.com) support on posts. To enable, set your key in Refinery's settings area.

## Requirements

Refinery CMS version 3.0.0 or above.

## Install

Open up your ``Gemfile`` and at the bottom, add this line:


```ruby
gem 'refinerycms-blog', git: 'https://github.com/refinery/refinerycms-blog', branch: 'master'
```

Note: if the [refinerycms-page-images](https://github.com/refinery/refinerycms-page-images) extension is also installed, make sure `gem refinerycms-blog` comes before `gem 'refinerycms-page-images'`.

Now, run ``bundle install``

Next, to install the blog plugin run:

    rails generate refinery:blog

Run database migrations:

    rake db:migrate

Finally seed your database and you're done.

    rake db:seed

## Visual Editor

By default, this extension does not require any particular visual editor.
Previously, Refinery was coupled to WYMeditor but this has been extracted to an
extension, [refinerycms-wymeditor](https://github.com/parndt/refinerycms-wymeditor).

If you want to use `refinerycms-wymeditor`, simply place it in your Gemfile:

```ruby
gem 'refinerycms-wymeditor', ['~> 1.0', '>= 1.0.6']
```

## Developing & Contributing

The version of Refinery to develop this engine against is defined in the gemspec. To override the version of refinery to develop against, edit the project Gemfile to point to a local path containing a clone of refinerycms.

### Testing

Generate the dummy application to test against

    $ bundle exec rake refinery:testing:dummy_app

Run the test suite with [Guard](https://github.com/guard/guard)

    $ bundle exec guard start

Or just with rake spec

    $ bundle exec rake spec

## Additional Features
* To limit rss feed length, use the 'max_results' parameter

    http://test.host/blog/feed.rss?max_results=10

## More Information
* Check out our [Website](http://refinerycms.com/)
* Documentation is available in the [guides](http://refinerycms.com/guides)
* Questions can be asked on our [Google Group](http://group.refinerycms.org)
* Questions can also be asked in our IRC room, [#refinerycms on freenode](irc://irc.freenode.net/refinerycms)
