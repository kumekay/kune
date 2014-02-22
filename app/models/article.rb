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
  scope :approved, ->{where(approved: true).order(approved_at: :desc)} 
  scope :unapproved, ->{where(approved: false).order(created_at: :desc)} 

  has_and_belongs_to_many :categories
  accepts_nested_attributes_for :categories, allow_destroy: true
  belongs_to :user
  
  before_validation :sanitize_evil_tags
  before_save :set_appoved_at

  validates :title, presence: true, length: { minimum: 5 }
  validates :summary, presence: true, length: { minimum: 10 }
  validates :body, presence: true, length: { minimum: 100 }

  paginates_per 20

  private

  # Set date of approvement 
  def set_appoved_at 
    if self.approved && !Article.find(self.id).approved
      self.approved_at = DateTime.now
    end
  end

  def sanitize_evil_tags
    self.summary = sanitize self.summary, tags: TINY_REDACTOR_TAGS , attributes: TINY_REDACTOR_ATTRS
    self.body = sanitize self.body, tags: REDACTOR_TAGS , attributes: REDACTOR_ATTRS
  end
end
