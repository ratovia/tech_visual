class ShiftsController < ApplicationController
  before_action :authenticate_user!

  def index
    redirect_to admin_shifts_path unless current_user.admin?
    @workroles = WorkRole.all
    # @days = (Date.current.beginning_of_month..Date.current.end_of_month).to_a
    @days = (Date.new(2020,2,1)..Date.new(2020,2,1)).to_a
    @users = User.where.not(role: :admin).includes(:attendances, :shifts)
  end

  def update
    user_genom = User.build_user_genom(user_genom_params)
    new_shifts = Shift.build_from_user_genom(user_genom_params[:day].to_date, user_genom)
    old_shifts = User.find(user_genom_params[:user_id]).shifts.on_thisday(user_genom_params[:day].to_date)
    ActiveRecord::Base.transaction do
      old_shifts.map(&:destroy!)
      new_shifts.map(&:save!)
    end
    render :update, format: :json
  end

  private

  def user_genom_params
    params.permit(:day, :user_id, shift_array: [])
  end
end
