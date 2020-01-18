ActiveAdmin.register Shift do
  permit_params :work_role_id, :user_id, :shift_in_at, :shift_out_at

  filter :user
  filter :work_role
  filter :shift_in_at
  filter :shift_out_at

  controller do
    def index
      redirect_to new_user_session_path and return unless user_signed_in?
      super
    end
  end

  # views
  index do
    if user_signed_in?.nil? || current_user.employee?
      render partial: 'index'
    else
      render partial: 'admin_index'
    end
  end
end
