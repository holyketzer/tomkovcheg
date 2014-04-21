class Article < ActiveRecord::Base
  validates :title, :abstract, :body, presence: true

  belongs_to :category
  has_many :images, as: :imageable

  scope :active, -> { where(published: true).where(approved: true) }
end
