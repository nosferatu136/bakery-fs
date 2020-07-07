class Oven < ActiveRecord::Base
  include HasCookies

  belongs_to :user
  has_many :cookies, as: :storage

  validates :user, presence: true

  def cookies_ready?
    cookie_status = cookies.map(&:ready?).uniq.compact
    cookie_status.size == 1 && cookie_status.first
  end
end
