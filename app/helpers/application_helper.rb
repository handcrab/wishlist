module ApplicationHelper
  def owned_wishes_page?
    current_page? owned_wishes_path
  end

  def formatted_date date
    l date, format: :short
  end
end
