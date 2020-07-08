module HasCookies
  extend ActiveSupport::Concern

  def cookies_by_fillings
    @cookies_by_fillings ||= cookies.group_by(&:fillings)
  end
end