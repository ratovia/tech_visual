ActiveAdmin.register RequiredResource do
  permit_params :what_day, :clock_at, :count, :work_role_id

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :what_day, :clock_at, :count, :work_role_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:what_day, :clock_at, :count, :work_role_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
