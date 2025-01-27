require "test_helper"

class OmniauthCallbacksControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Omniauthの認証情報をモックする
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      provider: 'twitter',
      uid: '123456',
      info: {
        name: 'Test User',
        image: 'http://example.com/test_user.jpg'
      },
      credentials: {
        token: 'mock_oauth_token',
        secret: 'mock_oauth_token_secret'
      }
    })
  end

  test "should get twitter" do
    get "/users/auth/twitter2/callback" # このパスでコールバックを受け取る
    assert_response :redirect
  end
end
