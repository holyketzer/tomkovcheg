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
      new_user = build(:user)

      click_on 'Регистрация'

      fill_in_user_fields(new_user) { click_on 'Зарегистрироваться' }

      expect(current_path).to eq(root_path)
      expect(page).to have_link 'Профиль'
      expect(page).to have_link 'Выход'

      expect_account_page(new_user)
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

    scenario 'sees profile' do
      expect_account_page(user)
    end

    scenario 'edits profile' do
      updated_user = build(:user)
      click_on 'Профиль'
      click_on 'Редактировать'

      fill_in_user_fields(updated_user) do
        fill_in 'Текущий пароль', with: user.password
        click_on 'Сохранить'
      end

      expect_account_page(updated_user)
    end
  end

  private

  def expect_account_page(user)
    click_on 'Профиль'

    expect(page).to have_content user.email
    expect(page).to have_content user.nickname
  end

  def fill_in_user_fields(user)
    within '.registration' do
      fill_in 'Email', with: user.email
      fill_in 'Имя пользователя', with: user.nickname
      fill_in 'Пароль', with: user.password
      fill_in 'Подтверждение пароля', with: user.password_confirmation
      yield if block_given?
    end
  end
end