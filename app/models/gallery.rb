class Gallery < ActiveRecord::Base
  validates :title, presence: true

  has_many :images, as: :imageable

  default_scope { order('created_at DESC') }

  accepts_nested_attributes_for :images

  paginates_per 10
end
