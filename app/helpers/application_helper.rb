module ApplicationHelper
  def title(t)
    content_for(:title, t.to_s)
  end
end
