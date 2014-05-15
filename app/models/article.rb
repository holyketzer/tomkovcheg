class Article < ActiveRecord::Base
  validates :title, :abstract, :body, presence: true

  belongs_to :category
  has_many :images, as: :imageable

  def active?
    published && approved
  end

  scope :active, -> { where(published: true).where(approved: true) }

  accepts_nested_attributes_for :images
end
