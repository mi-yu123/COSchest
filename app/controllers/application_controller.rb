class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_up_path_for(resource)
    new_user_session_path
  end
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end
