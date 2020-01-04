class Api::ShiftGeneratorController < ApplicationController
  def create
    users = User.where(role: "employee").includes(:attendances)
    workroles = WorkRole.all
    s = ShiftGenerator.new(users, workroles)
    # TODO  期間を渡す
    @result = s.generate()
  end
end
