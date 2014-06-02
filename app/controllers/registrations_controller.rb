class RegistrationsController < Devise::RegistrationsController
  def show
    if user_signed_in?
      @user = current_user
    else
      redirect_to new_user_registration_path
    end
  end
end