class ApplicationController < ActionController::Base

  def access_denied(exception)
    if current_user
      redirect_to admin_root_path
    else
      redirect_to new_user_session_path, alert: exception.message
    end
  end
end
