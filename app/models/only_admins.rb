class OnlyAdmins < ActiveAdmin::AuthorizationAdapter

  # Visiting of administration area is allowed only for admins
  def authorized?(action, subject = nil)
    user.admin?
  end

end