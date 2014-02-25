class User < ActiveRecord::Base
  scope :today, -> {User.where("created_at > ?", 1.day.ago)}
  
  has_many :articles
  has_many :subscriptions

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :async, :confirmable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable 
  validates :name, presence: { message: 'необходимо указать'},
                   length: { in: 2..32, message: 'должно быть длиной от 2 до 32 символов' }     


end
