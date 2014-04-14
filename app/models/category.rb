class Category < ActiveRecord::Base
  validates :title, :priority, presence: true
  validates :title, uniqueness: { case_sensitive: false }

  has_many :articles
end
