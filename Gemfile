source 'https://rubygems.org'
ruby '2.1.0'
gem 'rails', '4.0.3'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jquery-turbolinks' #document.ready action fix 
gem 'jbuilder', '~> 1.2'
gem 'bootstrap-sass', '>= 3.0.0.0' # Bootstrap support
gem 'twitter-bootstrap-rails' # Just for some helpers and generators
gem 'devise'
gem 'pg'
gem 'slim-rails'
gem 'thin'
gem 'acts-as-taggable-on' # Tags
gem 'kaminari' # Pagination
gem 'activeadmin', github: 'gregbell/active_admin'
gem 'russian', '~> 0.6.0' # We are Russians
gem 'redactor-rails' # Editor
gem "carrierwave"
gem "mini_magick"
gem 'faker' # Test data

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[ :mri_21]
  gem 'hub', :require=>nil
  gem 'quiet_assets'
  gem 'rails_layout'
  gem 'bullet' # N+1 detector
end
group :development, :test do
  gem 'rspec-rails'
end
group :test do
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
end

group :production do
  gem 'rails_12factor'
end