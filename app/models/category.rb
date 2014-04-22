class Category < ActiveRecord::Base
  validates :title, :priority, presence: true
  validates :title, uniqueness: { case_sensitive: false }

  has_many :articles
  has_one :image, as: :imageable

  accepts_nested_attributes_for :image
end
