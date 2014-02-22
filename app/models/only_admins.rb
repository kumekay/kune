class OnlyAdmins < ActiveAdmin::AuthorizationAdapter

  #  Only admins are allowed to visit administration area
  def authorized?(action, subject = nil)
    user.admin?
  end

end