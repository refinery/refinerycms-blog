# Refinery CMS Blog

Simple blog engine for [Refinery CMS](http://refinerycms.com). It supports posts, categories and comments.

This version of `refinerycms-blog` supports Rails 3.2.x. To use Rails 2.3.x use the [refinerycms-blog "Rails 2.3.x stable branch"](http://github.com/resolve/refinerycms-blog/tree/rails2-stable).

Options:

* Comment moderation
* [ShareThis.com](http://sharethis.com) support on posts. To enable, set your key in Refinery's settings area.

## Requirements

Refinery CMS version 2.0.1 or above.

## Install

Open up your ``Gemfile`` and add at the bottom this line:

```ruby
gem 'refinerycms-blog', '~> 2.0.0'
```

Now, run ``bundle install``

Next, to install the blog plugin run:

    rails generate refinery:blog

Run database migrations:

    rake db:migrate

Finally seed your database and you're done.

    rake db:seed

## Developing & Contributing

The version of Refinery to develop this engine against is defined in the gemspec. To override the version of refinery to develop against, edit the project Gemfile to point to a local path containing a clone of refinerycms.

### Testing

Generate the dummy application to test against

    $ bundle exec rake refinery:testing:dummy_app

Run the test suite with [Guard](https://github.com/guard/guard)

    $ bundle exec guard start

Or just with rake spec

    $ bundle exec rake spec

## More Information
* Check out our [Website](http://refinerycms.com/)
* Documentation is available in the [guides](http://refinerycms.com/guides)
* Questions can be asked on our [Google Group](http://group.refinerycms.org)
* Questions can also be asked in our IRC room, [#refinerycms on freenode](irc://irc.freenode.net/refinerycms)