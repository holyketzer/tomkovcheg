require 'spec_helper'

feature 'User login', %q{
  In order to post comments
  As an user
  I want to login into site
 } do

  background do
    visit root_path
  end

  context 'unauthenticated user' do
    scenario 'can login or create account' do
      expect(page).to have_submit_button 'Войти'
      expect(page).to have_link 'Регистрация'
    end

    scenario 'creates new account' do
      user = build(:user)

      click_on 'Регистрация'

      within '.registration' do
        fill_in 'Email', with: user.email
        fill_in 'Пароль', with: user.password
        fill_in 'Подтверждение пароля', with: user.password_confirmation
        click_on 'Зарегистрироваться'
      end

      expect(current_path).to eq(root_path)
      expect(page).to have_link 'Профиль'
      expect(page).to have_link 'Выход'
    end

    scenario "can't see profile" do
      visit account_path
      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content 'Для просмотра профиля необходимо войти'
    end
  end

  context 'authenticated user' do
    let(:user) { create(:user) }

    background do
      login_as user
    end

    scenario 'successefull login' do
      expect(current_path).to eq(root_path)
      expect(page).to have_link 'Профиль'
      expect(page).to have_link 'Выход'
      expect(page).to have_content 'Вход на сайт выполнен'
    end

    scenario 'logout' do
      click_on 'Выход'

      expect(page).to have_submit_button 'Войти'
      expect(page).to have_content 'Выход с сайта выполнен'
    end
  end
end