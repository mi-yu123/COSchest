module ApplicationHelper
  def format_month_year(date)
    date.strftime('%Y年%m月') if date.present?
  end
end
