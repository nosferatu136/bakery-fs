class User < ActiveRecord::Base
  include HasCookies
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :ovens
  has_many :stored_cookies, class_name: 'Cookie', as: :storage

  before_create :setup_first_oven

  alias_method :cookies, :stored_cookies

  private

  def setup_first_oven
    ovens.new(name: 'My First Oven')
  end

end
