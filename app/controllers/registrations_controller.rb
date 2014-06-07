class RegistrationsController < Devise::RegistrationsController
  def new
    self.resource = User.new
    auth = session['devise.oauth']

    if auth.present?
      self.resource.email = auth['info']['email']
      self.resource.nickname = auth['info']['nickname']
    end

    avatar_id = session['devise.avatar_id']
    if avatar_id
      self.resource.avatar = Image.find(avatar_id)
    end
  end

  def create
    super do |user|
      auth = session['devise.oauth']
      user.create_authentication(auth) if auth
    end
  end

  def show
    if user_signed_in?
      @user = current_user
    else
      redirect_to new_user_session_path, notice: 'Для просмотра профиля необходимо войти'
    end
  end
end