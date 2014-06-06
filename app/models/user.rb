class User < ActiveRecord::Base
  has_one :avatar, class_name: 'Image', as: :imageable

  validates :nickname, presence: true
  validates :nickname, uniqueness: { case_sensitive: false }

  accepts_nested_attributes_for :avatar

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
