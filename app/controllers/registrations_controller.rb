class RegistrationsController < Devise::RegistrationsController
  def show
    if user_signed_in?
      @user = current_user
    else
      redirect_to new_user_session_path, notice: 'Для просмотра профиля необходимо войти'
    end
  end
end