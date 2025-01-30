class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    @user = User.find_or_create_by(uid: auth.uid, provider: auth.provider) do |user|
      user.name = auth.info.name
      user.image = auth.info.image
      user.oauth_token = auth.credentials.token
      user.oauth_token_secret = auth.credentials.secret
    end

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.twitter_data'] = auth.except("extra")
      redirect_to new_user_registration_url
    end
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end
