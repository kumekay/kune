ThinkingSphinx::Index.define :article, :with => :active_record do
  # fields
  indexes title
  indexes summary
  indexes body
  indexes user.name

  # attributes
  has :approved, :fresh, :approved_at
end