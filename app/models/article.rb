class Article < ActiveRecord::Base
  validates :title, :body, presence: true

  belongs_to :category
  has_many :images, as: :imageable

  def active?
    published && approved
  end

  default_scope { order('created_at DESC') }
  scope :active, -> { where(published: true).where(approved: true) }

  accepts_nested_attributes_for :images

  paginates_per 5
end
