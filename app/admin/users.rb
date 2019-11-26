ActiveAdmin.register User do
  permit_params :name, :role, :email, :password, :password_confirmation

  filter :name

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :role
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :role
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
