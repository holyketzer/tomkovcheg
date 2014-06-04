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
  end
end