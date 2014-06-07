require 'spec_helper'
require 'webmock/rspec'

feature 'User authentication', %q{
  In order to post comments
  As an user
  I want to login into site
 } do

  describe 'OAuth registration' do
    before do
      stub_request(:get, 'www.imagehost.test/avatar.jpg').to_return(body: File.new(build(:image_path)), status: 200)
    end

    scenario 'with full user information' do
      visit new_user_session_path
      OmniAuth.config.add_mock(:vkontakte, { uid: '12345', info: { email: 'test@mail.com', nickname: 'Nick'}, extra: { raw_info: { photo_200_orig: 'http://www.imagehost.test/avatar.jpg' }}})

      click_on 'Войти через Vkontakte'

      expect(current_path).to eq(root_path)
      expect(page).to have_content 'Вход в систему выполнен с учётной записью из Vkontakte'

      visit account_path
      within '.avatar' do
        expect(page).to have_image 'avatar.jpg'
      end
    end

    context 'without full user information' do
      scenario 'vkontakte' do
        visit new_user_session_path

        user = build(:user)
        OmniAuth.config.add_mock(:vkontakte, { uid: '12345', info: {}, extra: { raw_info: {} } })

        click_on 'Войти через Vkontakte'

        expect(current_path).to eq(new_user_registration_path)
        expect(page).to have_content 'Пожалуйста, завершите регистрацию'
        fill_in_user_fields(user) { click_on 'Зарегистрироваться' }

        within '#loginbox' do
          expect(current_path).to eq(root_path)
          expect(page).to have_content user.email
          expect(page).to have_link 'Профиль'
          click_on 'Выход'
        end

        visit new_user_session_path
        click_on 'Войти через Vkontakte'
        expect(page).to have_content 'Вход в систему выполнен с учётной записью из Vkontakte'
      end
    end
  end
end