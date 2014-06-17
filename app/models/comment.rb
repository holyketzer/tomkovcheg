class Comment < ActiveRecord::Base
  validates :body, :article, :user, presence: true

  belongs_to :user
  belongs_to :article

  default_scope { order('created_at') }
end