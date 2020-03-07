class ShiftsController < ApplicationController
  before_action :authenticate_user!

  def index
    redirect_to admin_shifts_path unless current_user.admin?
    @workroles = WorkRole.all
    # @days = (Date.current.beginning_of_month..Date.current.end_of_month).to_a
    @days = (Date.new(2020,2,1)..Date.new(2020,2,1)).to_a
    @users = User.all
  end

  def update
    binding.pry
  end

  private

  def shift_params
    params.permit(:day, :user_id, :shift_array)
  end
end
