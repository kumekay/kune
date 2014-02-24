class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # When user without auth trying to get to admin area
  def admin_access_denied(exception)
    redirect_to root_path, alert: exception.message
  end
end
