class Role < ActiveRecord::Base
  has_many :role_permissions
  has_many :permissions, through: :role_permissions

  validates :name, presence: true

  def self.user
    find_by name: 'user'
  end

  def self.moderator
    find_by name: 'moderator'
  end

  def self.admin
    find_by name: 'admin'
  end
end