require 'spec_helper'

feature 'User account', %q{
  In order to post comments
  As an user
  I want to have an account
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

      fill_in_user_fields(new_user, build(:image_path)) { click_on 'Зарегистрироваться' }

      expect(current_path).to eq(root_path)
      expect(page).to have_link 'Профиль'
      expect(page).to have_link 'Выход'

      expect_account_page(new_user)

      new_user = User.find_by_email(new_user.email)
      expect(new_user.avatar).to_not be_nil
    end

    scenario "can't see profile" do
      visit account_path
      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content 'Для просмотра профиля необходимо войти'
    end
  end

  context 'authenticated user' do
    let(:avatar) { create(:avatar) }
    let(:user) { create(:user, avatar: avatar) }

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

      fill_in_user_fields(updated_user, build(:image_path)) do
        fill_in 'Текущий пароль', with: user.password
        click_on 'Сохранить'
      end

      expect_account_page(updated_user)

      updated_user = User.find_by_email(updated_user.email)
      expect(updated_user.avatar).to_not be_nil
      expect(updated_user.avatar.source).to_not eq avatar.source
    end
  end

  private

  def expect_account_page(user)
    click_on 'Профиль'

    expect(page).to have_content user.email
    expect(page).to have_content user.nickname
    expect(page).to have_image user.avatar.thumb_url if user.avatar
  end
end