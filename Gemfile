source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.2'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

gem 'therubyracer'
gem 'less-rails' #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem 'twitter-bootstrap-rails', git: 'git://github.com/seyhunak/twitter-bootstrap-rails.git'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

gem 'slim-rails'
gem 'russian'
gem 'inherited_resources'
gem 'simple_form'
gem 'carrierwave'
gem 'mini_magick' # ensure that imagemagick is installed: 'sudo apt-get install imagemagick'
gem 'bootstrap-wysihtml5-rails' # wysiwyg editor
gem 'kaminari' # pagination
gem 'gretel' # breadcrumbs
gem 'devise' # authentication
gem 'omniauth-vkontakte', git: 'git://github.com/mamantoha/omniauth-vkontakte.git' # should be 1.3.3 but it hasn't been released yet
gem 'omniauth-facebook'
gem 'figaro' # Keep secrets in separate config
gem 'cancancan', '~> 1.8' # authorization

#gem 'open-uri', require: false
gem 'open_uri_redirections', require: false # for handling tricky redirects in social network avatar's urls

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring', group: :development


group :development, :test do
  gem 'launchy'
  gem 'minitest'
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'pry-plus'
end

group :test do
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'capybara-webkit'
  gem 'webmock'
end