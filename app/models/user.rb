class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :name, presence: { message: 'необходимо указать'},
                   length: { in: 2..32, message: 'должно быть длиной от 2 до 32 символов' }     
end
