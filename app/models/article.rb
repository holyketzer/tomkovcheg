class Article < ActiveRecord::Base
  validates :title, :abstract, :body, presence: true

  belongs_to :category

  scope :active, -> { where(published: true).where(approved: true) }
end
