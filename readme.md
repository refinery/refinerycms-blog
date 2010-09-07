Install

Open up your GemFile and add at the bottom this line

gem 'refinerycms-blog', '= 1.0.rc6'

Now run ``bundle install``

Next to install it run:

ruby script/generate refinery_blog

Finally migration your database and you're done.

rake db:migrate