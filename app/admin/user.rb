ActiveAdmin.register User do
  permit_params :name, :admin, :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :admin
    actions
  end

  filter :email
  filter :admin

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs :name
    f.inputs :email
    f.inputs :admin
    f.actions
  end

end
