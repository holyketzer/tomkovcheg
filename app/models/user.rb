class User < ActiveRecord::Base
  has_many :authentications
  has_one :avatar, class_name: 'Image', as: :imageable
  belongs_to :role
  has_many :permissions, through: :role
  has_many :comments

  validates :nickname, presence: true
  validates :nickname, uniqueness: { case_sensitive: false }

  accepts_nested_attributes_for :avatar

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:vkontakte, :facebook]

  before_create { |user| user.role = Role.user unless user.role }

  def self.find_by_oauth(auth)
    authentication = Authentication.where(provider: auth.provider, uid: auth.uid.to_s).first
    if authentication
      user = authentication.user
    else
      email = auth.info[:email]
      nickname = auth.info[:nickname]
      user = User.where(email: email).first
      if user
        user.create_authentication(auth)
      elsif email.present? && nickname.present?
        password = Devise.friendly_token[0, 20]
        user = User.create(email: email, password: password, password_confirmation: password, nickname: nickname)
        user.create_authentication(auth)
      end
    end
    user
  end

  def create_authentication(auth)
    self.authentications.create!(provider: auth['provider'], uid: auth['uid'])
  end

  def add_authentication(auth)
    authentication = Authentication.where(provider: auth.provider, uid: auth.uid.to_s).first
    if authentication
      authentication.user == self
    else
      create_authentication(auth)
      true
    end
  end

  def admin?
    role == Role.admin
  end
end
