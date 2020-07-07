class Cookie < ActiveRecord::Base
  belongs_to :storage, polymorphic: :true
  before_save :sanitize

  validates :storage, presence: true

  def ready?
    true
  end

  private

  def sanitize
    self.fillings = nil if fillings.blank?
  end
end
