class User < ActiveRecord::Base
  scope :today, -> {User.where("created_at > ?", 1.day.ago)}
  
  has_many :articles
  has_many :subscriptions

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :async, :confirmable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]
  validates :name, presence: { message: 'необходимо указать'},
                   length: { in: 2..32, message: 'должно быть длиной от 2 до 32 символов' }     

  # find user from omniauth
  def self.find_for_facebook_oauth(omniauth)
    return if omniauth.nil?
    user = User.find_by(provider: omniauth['provider'], uid: omniauth['uid']) 
    
    unless user # if it's user first time
      email = omniauth['info']['email']
      unless user = User.find_by(email: email) # And it doesn't registerer
        user = User.create!(:email => email, \
                            :password => Devise.friendly_token[0, 20], \
                            :provider => omniauth['provider'], \
                            :uid => omniauth['uid'], \
                            :name => omniauth['info']['name'])
        user.confirm!
      else
        user.update(:provider => omniauth['provider'], :uid => omniauth['uid'])
      end
    end

    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

end
