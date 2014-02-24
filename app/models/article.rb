class Article < ActiveRecord::Base
  include ActionView::Helpers
  # Tags allowed for editor
  TINY_REDACTOR_TAGS = %w(p pre code strong em h1 h2 h3 h4 h5 h6)
  TINY_REDACTOR_ATTRS = []
  REDACTOR_TAGS = %w(code span div label a br p b i del strike u img video audio
                iframe object embed param blockquote mark cite small ul ol li
                hr dl dt dd sup sub big pre code figure figcaption strong em
                table tr td th tbody thead tfoot h1 h2 h3 h4 h5 h6)
  REDACTOR_ATTRS = %w(src href width height frameborder allowfullscreen)

  # News sorted by approving date
  scope :fresh, ->{where(fresh: true).includes(:user, :categories)}
  scope :approved, ->{where(fresh: false, approved: true).includes(:user, :categories).order(approved_at: :desc)} 
  scope :declined, ->{where(fresh: false, approved: false).includes(:user, :categories).order(created_at: :desc)} 

  has_and_belongs_to_many :categories
  accepts_nested_attributes_for :categories, allow_destroy: true
  belongs_to :user
  
  before_validation :sanitize_evil_tags

  validates :title, length: { in: 5..200 }
  validates :summary, length: { in: 10..1000 }
  validates :body, length: { minimum: 100 }
  validates :user, presence: true

  #Comments
  acts_as_commentable

  paginates_per 20

  # Approve article and show to public
  def approve
    if self.fresh?
      params = {fresh: false,
                approved: true}
      # Don't update approvation date if it already set                
      params.merge!(approved_at: DateTime.now) unless self.approved_at
      self.update(params)
    end
  end

  # Decline article
  def decline
    if self.fresh?
      self.update(
        fresh: false,
        approved: false)
    end
  end

  def to_param 
    "#{id}-#{title.parameterize}"
  end

  private

  # remove dangerous html tags before save
  def sanitize_evil_tags
    self.summary = sanitize self.summary, tags: TINY_REDACTOR_TAGS , attributes: TINY_REDACTOR_ATTRS
    self.body = sanitize self.body, tags: REDACTOR_TAGS , attributes: REDACTOR_ATTRS
  end
end
