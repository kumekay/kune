# a simple/configurable rake task that generates some random fake data for the app (using faker) at various sizes
# NOTE: requires the faker or ffaker gem 
#   sudo gem install faker - http://faker.rubyforge.org
#   OR
#   sudo gem install ffaker - http://github.com/EmmanuelOga/ffaker

require 'faker'

class Fakeout

  # START Customizing

  # 1. first these are the model names we're going to fake out, note in this example, we don't create tags/taggings specifically
  # but they are defined here so they get wiped on the clean operation
  # e.g. this example fakes out, Users, Questions and Answers, and in doing so fakes some Tags/Taggings
  MODELS = [['User', 5], ['Category', 4], ['Article', 50], ['Comment',30], ['Subscription', 3]]

  # 2. now define a build method for each model, returning a list of attributes for Model.create! calls
  # check out the very excellent faker gem rdoc for faking out anything from emails, to full addresses; http://faker.rubyforge.org/rdoc
  # NOTE: a build_??? method MUST exist for each model you specify above
  def build_user(username = Faker::Name.first_name, email = Faker::Internet.email, password = 'password', admin = false)
    { name:                  username,
      email:                 email,
      password:              password,
      password_confirmation: password,
      admin:                 admin }
  end


  def build_category
    { title:             Faker::Lorem.word}
  end

  # in this example i'm faking out time again! - this time to be after the question's created at time
  def build_article

    { title:            Faker::Lorem.sentence(5),
      summary:          Faker::Lorem.paragraph(3),
      body:             Faker::Lorem.paragraph(20),
      user:             User.first(:order => "RANDOM()"),
      approved_at:      fake_time_from(1.year.ago), 
      approved:         rand(2) > 0,
      fresh:            rand(2) > 0,
      category_ids:     Category.order("RANDOM()").limit(2).pluck(:id)
    }
  end

  # return nil, or an empty hash for models you don't want to be faked out on create, but DO want to be clearer away
  def build_comment
    { body:             Faker::Lorem.sentence(5),
      user:             User.first(:order => "RANDOM()"),
      username:         Faker::Name.name,
      commentable_type: "Article",
      commentable_id:   Article.first(:order => "RANDOM()"),
    }
  end

  def build_subscription
    { user:             User.first(:order => "RANDOM()"),
      category:         Category.first(:order => "RANDOM()")
    }
  end
  
  # called after faking out, use this method for additional updates or additions
  def post_fake
    u = User.create!(build_user('ku', 'po@kumekay.com', 'qwerty', true))
    u.confirm!
  end

  # END Customizing

  attr_accessor :all_tags, :size

  def initialize(prompt=true)
    self.all_tags = Faker::Lorem.words(5)
  end

  def fakeout
    puts "Faking it ..."
    Fakeout.disable_mailers
    MODELS.each do |elem|
      model, size = *elem
      if !respond_to?("build_#{model.downcase}")
        puts "  * #{model.pluralize}: **warning** I couldn't find a build_#{model.downcase} method"
        next
      end
      1.upto(size) do
        attributes = send("build_#{model.downcase}")
        model.constantize.create!(attributes) if attributes && !attributes.empty?
      end
      puts "  * #{model.pluralize}: #{model.constantize.count(:all)}"
    end
    post_fake
    puts "Done, I Faked it!"
  end
  
  def self.prompt
    puts "Really? This will clean all #{MODELS.map{|i| i.first}.map(&:pluralize).join(', ')} from your database y/n? "
    STDOUT.flush
    (STDIN.gets =~ /^y|^Y/) ? true : exit(0)
  end

  def self.clean(prompt = true)
    self.prompt if prompt
    puts "Cleaning all ..."
    Fakeout.disable_mailers
    MODELS.map{|i| i.first}.each do |model|
      model.constantize.delete_all
    end
  end

  # by default, all mailings are disabled on faking out
  def self.disable_mailers
    ActionMailer::Base.perform_deliveries = false
  end
  
  
  private
  # pick a random model from the db, done this way to avoid differences in mySQL rand() and postgres random()
  def pick_random(model, optional = false)
    return nil if optional && (rand(2) > 0)
    ids = ActiveRecord::Base.connection.select_all("SELECT id FROM #{model.to_s.tableize}")
    model.find(ids[rand(ids.length)]['id'].to_i) if ids
  end

  # useful for prepending to a string for getting a more unique string
  def random_letters(length = 2)
    Array.new(length) { (rand(122-97) + 97).chr }.join
  end

  # pick a random number of tags up to max_tags, from an array of words, join the result with seperator
  def random_tag_list(tags, max_tags = 5, seperator = ',')
    start = rand(tags.length)
    return '' if start < 1
    tags[start..(start+rand(max_tags))].join(seperator)
  end

  # fake a time from: time ago + 1-8770 (a year) hours after
  def fake_time_from(time_ago = 1.year.ago)
    time_ago+(rand(8770)).hours
  end
end


# the tasks, hook to class above - use like so;
# rake fakeout:clean
# rake fakeout:small[noprompt] - no confirm prompt asked, useful for heroku or non-interactive use
# rake fakeout:medium RAILS_ENV=bananas
#.. etc.
namespace :fakeout do

  desc "clean away all data"
  task :clean, [:no_prompt] => :environment do |t, args|
    Fakeout.clean(args.no_prompt.nil?)
  end
  
  desc "fake out a dataset"
  task :fake, [:no_prompt] => :clean do |t, args|
    Fakeout.new().fakeout
  end

end
