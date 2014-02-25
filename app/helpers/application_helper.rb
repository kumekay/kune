module ApplicationHelper
  def active_path(path)
    "active" if current_page?(path)
  end
end
