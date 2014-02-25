class Category < ActiveRecord::Base
  has_and_belongs_to_many :articles
  has_many :subscriptions

  validates :title, presence: true, uniqueness: true

  def to_param 
    "#{id}-#{title.parameterize}"
  end
end
