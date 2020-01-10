class Api::ShiftGeneratorController < ApplicationController
  def create
    users = User.where(role: "employee").includes(:attendances)
    workroles = WorkRole.all
    s = ShiftGenerator.new(users, workroles)
    @result = s.generate(period_params)
    @workrole_ids = workroles.map(&:id)
  end

  private

  def period_params
    @period = params.permit(:start, :finish)
  end
end
