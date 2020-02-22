class Api::ShiftGeneratorsController < ApplicationController

  def show
    if user_signed_in? && current_user.admin?
      users = User.where(role: "employee").includes(:attendances)
      workroles = WorkRole.all
      sgg = ShiftGeneticGenerator.new(users, workroles)
      @genoms = sgg.generate(period_params)
    else
      redirect_to root_path
    end
  end

  private

  def period_params
    @period = params.permit(:start, :finish)
  end
end
