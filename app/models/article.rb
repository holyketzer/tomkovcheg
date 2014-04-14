class Article < ActiveRecord::Base
  validates :title, :abstract, :body, presence: true

  belongs_to :category
end
