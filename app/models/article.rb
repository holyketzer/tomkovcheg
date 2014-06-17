class Article < ActiveRecord::Base
  validates :title, :body, presence: true

  belongs_to :category
  has_many :images, as: :imageable
  has_many :comments

  default_scope { order('created_at DESC') }
  scope :visible, -> { where(published: true) }

  accepts_nested_attributes_for :images

  paginates_per 5
end
