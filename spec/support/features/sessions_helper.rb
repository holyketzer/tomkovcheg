module Features
  module SessionsHelper
    def sign_in_with(email, password)
      within '#loginbox' do
        fill_in 'Email', with: email
        fill_in 'Пароль', with: password
        click_on 'Войти'
      end
    end

    def login_as(user)
      visit new_user_session_path
      sign_in_with user.email, user.password
    end

    def fill_in_user_fields(user, avatar_path = nil)
      within '.registration' do
        fill_in 'Email', with: user.email
        fill_in 'Имя пользователя', with: user.nickname
        fill_in 'Пароль', with: user.password
        fill_in 'Подтверждение пароля', with: user.password_confirmation
        attach_file 'Аватар', avatar_path if avatar_path
        yield if block_given?
      end
    end
  end
end