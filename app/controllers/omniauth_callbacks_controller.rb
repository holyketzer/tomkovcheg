class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  #before_action :oauth_callback

  def vkontakte
    auth = request.env['omniauth.auth']

    auth.info[:nickname] = nil if auth.info[:nickname].to_s.empty?
    auth.info[:nickname] ||= auth.extra.raw_info[:screen_name]
    auth.info[:nickname] ||= "#{auth.extra.raw_info[:first_name]} #{auth.extra.raw_info[:last_name]}"
    auth.info[:image] = auth.extra.raw_info[:photo_200_orig]

    oauth_callback(auth)
  end

  private

  def oauth_callback(auth)
    provider = auth[:provider].capitalize

    if signed_in?
      if current_user.add_authentication(auth)
        flash[:notice] = t('devise.omniauth_callbacks.associated', provider: provider)
      else
        flash[:error] = t('devise.omniauth_callbacks.not_associated', provider: provider)
      end
      redirect_to account_path
    else
      @user = User.find_by_oauth(auth)
      if @user && @user.persisted?
        unless @user.avatar
          create_avatar(auth) { |avatar| @user.update!(avatar: avatar) }
        end
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
      else
        flash[:notice] = t('registration.new.finish')
        session['devise.oauth'] = auth
        create_avatar(auth) { |avatar| session['devise.avatar_id'] = avatar.id }
        redirect_to new_user_registration_path
      end
    end
  end

  def create_avatar(auth)
    avatar = nil
    if auth.info[:image]
      avatar = Image.create(remote_source_url: process_uri(auth.info[:image]))
      yield(avatar) if block_given? && avatar.source
    end
    avatar
  end

  def process_uri(uri)
    if uri
      require 'open-uri'
      require 'open_uri_redirections'
      open(uri, allow_redirections: :safe) do |r|
        r.base_uri.to_s
      end
    end
  end
end
