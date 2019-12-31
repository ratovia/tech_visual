class Api::ShiftGeneratorController < ApplicationController
  def create
    users = User.where(role: "employee").includes(:attendances)
    workroles = WorkRole.all
    s = ShiftGenerator.new(users, workroles)
    @result = s.generate(params[:start],params[:finish])
  end
end
