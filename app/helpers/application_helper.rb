module ApplicationHelper

  
  def active_path(path)
    "active" if current_page?(path)
  end

  # Array of all tags
  def article_tags
    Article.tag_counts.pluck(:name)
  end  

end
