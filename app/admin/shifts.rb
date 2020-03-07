ActiveAdmin.register Shift do
  permit_params :work_role_id, :user_id, :shift_in_at, :shift_out_at

  filter :user

  controller do
    def index
      redirect_to new_user_session_path and return unless user_signed_in?
      redirect_to shifts_path and return if current_user.admin?
      @workroles = WorkRole.all
      # @days = (Date.current.beginning_of_month..Date.current.end_of_month).to_a
      @days = (Date.new(2020,2,1)..Date.new(2020,2,2)).to_a
      @users = User.all
      super
    end
  end

  # views
  index do
    render partial: 'index'
  end
end
