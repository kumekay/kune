class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :category

  validates :user, presence: true, uniqueness: {scope: :category_id}
  validates :category, presence: true

  before_create :set_security_key

  private

  def set_security_key
    self.security_key = Digest::SHA2.hexdigest("#{self.category.id}_#{self.user.id}_#{DateTime.now.strftime('%Q')}_#{SecureRandom.hex( 16)}")
  end

end
