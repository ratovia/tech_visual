ActiveAdmin.register Shift do
  permit_params :work_role_id, :user_id, :shift_in_at, :shift_out_at

  filter :user

  controller do
    def index
      redirect_to new_user_session_path and return unless user_signed_in?
      # シフト編集はshifts#index(active_admin管理外)で行うことにしました
      redirect_to shifts_path and return if current_user.admin?
      @workroles = WorkRole.all
      # TODO 今月の初日〜末日の配列にする
      # @days = (Date.current.beginning_of_month..Date.current.end_of_month).to_a
      @days = (Date.new(2020,2,1)..Date.new(2020,2,29)).to_a
      super
    end
  end

  # views
  index do
    render partial: 'index'
  end
end
