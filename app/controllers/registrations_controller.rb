class RegistrationsController < Devise::RegistrationsController
  def new
    self.resource = User.new
    auth = session['devise.oauth']

    if auth.present?
      p auth
      p auth['info']
      self.resource.email = auth['info']['email']
      self.resource.nickname = auth['info']['nickname'] || auth['info']['screen_name']
    end

    avatar_id = session['devise.avatar_id']
    if avatar_id
      self.resource.avatar = Image.find(avatar_id)
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