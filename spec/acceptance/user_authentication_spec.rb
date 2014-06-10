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

      check_avatar 'avatar.jpg'
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

      scenario 'facebook' do
        user = build(:user)
        OmniAuth.config.add_mock(:facebook, {uid: '12345', info: { email: user.email, image: 'http://www.imagehost.test/avatar.jpg' }})

        visit new_user_session_path
        click_on 'Войти через Facebook'

        expect(current_path).to eq(new_user_registration_path)
        expect(page).to have_content 'Пожалуйста, завершите регистрацию'
        within '.registration' do
          expect(find_field('Email').value).to eq(user.email)
        end

        fill_in_user_fields(user) { click_on 'Зарегистрироваться' }

        within '#loginbox' do
          expect(current_path).to eq(root_path)
          expect(page).to have_content user.email
          expect(page).to have_link 'Профиль'
        end

        check_avatar 'avatar.jpg'
      end

      context 'with http to https avatar url redirect' do
        let(:avatar_url) { 'http://www.imagehost.com/avatar.jpg' }
        let(:redirection_url) { 'https://cdn.imagehost.com/redirected_avatar.jpg' }

        before do
          stub_request(:get, avatar_url).to_return(status: 302, headers: { 'Location' => redirection_url, 'Content-Type' => 'image/jpeg' })
          stub_request(:get, redirection_url).to_return(body: File.new(build(:image_path)), status: 200)
        end

        scenario 'facebook' do
          user = build(:user)
          OmniAuth.config.add_mock(:facebook, {uid: '12345', info: { email: user.email, image: avatar_url }})

          visit new_user_session_path
          click_on 'Войти через Facebook'

          fill_in_user_fields(user) { click_on 'Зарегистрироваться' }

          check_avatar 'redirected_avatar.jpg'
        end
      end
    end
  end

  describe 'OAuth association' do
    context 'signed up with Facebook' do
      let!(:user) { create(:user) }
      let!(:fb_auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
      let!(:vk_auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '789400') }

      before do
        OmniAuth.config.add_mock(vk_auth.provider, { uid: vk_auth.uid, info: { }, extra: { raw_info: {} } })
        user.create_authentication(fb_auth)
        login_as(user)
        visit account_path
      end

      scenario 'user add Vkontake account' do
        click_on 'Привязать к Vkontakte'

        expect(current_path).to eq(account_path)
        expect(page).to have_content 'Ваш профиль привязан к аккаунту Vkontakte'
        expect(page).to_not have_link 'Привязать к Vkontakte'
      end

      context 'Vkontakte profile assigned with another user' do
        let!(:vk_user) { create(:user) }
        before { vk_user.create_authentication(vk_auth) }

        scenario 'user can not add Vkontakte profile' do
          click_on 'Привязать к Vkontakte'

          expect(current_path).to eq(account_path)
          expect(page).to have_content 'Этот аккаунт Vkontakte уже связан с другим профилем'
          expect(page).to have_link 'Привязать к Vkontakte'
        end
      end
    end
  end

  describe 'user account' do
    let!(:user) { create(:user, authentications: [auth]) }
    before do
      login_as user
      visit account_path
    end

    context 'associated with Facebook' do
      let!(:auth) { create(:authentication, provider: 'facebook') }

      scenario 'user can see Facebook account details' do
        within '.authentications' do
          expect(page).to have_content 'Соц. сеть'
          expect(page).to have_content 'ID'

          expect(page).to have_content auth.provider
          expect(page).to have_content auth.uid
        end
      end

      scenario 'user can associate account' do
        within '.associate-account' do
          expect(page).to have_link 'Привязать к Vkontakte'
          expect(page).to_not have_link 'Привязать к Facebook'
        end
      end
    end

    context 'associated with Vkontakte' do
      let!(:auth) { create(:authentication, provider: 'vkontakte') }

      scenario 'user can see Facebook account details' do
        within '.authentications' do
          expect(page).to have_content auth.provider
          expect(page).to have_content auth.uid
        end
      end

      scenario 'user can associate account' do
        within '.associate-account' do
          expect(page).to_not have_link 'Привязать к Vkontakte'
          expect(page).to have_link 'Привязать к Facebook'
        end
      end
    end
  end

  private

  def check_avatar(avatar_file_name)
    visit account_path
      within '.avatar' do
        expect(page).to have_image avatar_file_name
      end
  end
end