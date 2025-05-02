require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.server_host = '0.0.0.0'
Capybara.server_port = 3001
Capybara.app_host = 'http://localhost:3000'

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :headless_chrome
  end
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :remote_chrome
    Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
    Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
  end
end

Capybara.register_driver :remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: ENV.fetch('SELENIUM_DRIVER_URL', 'http://chrome:4444/wd/hub'),
    options: options
  )
end

Capybara.javascript_driver = :remote_chrome
