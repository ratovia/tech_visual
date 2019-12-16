class WelcomeController < ApplicationController
  def create
    seeding
    users = User.all.includes(:attendances)
    workroles = WorkRole.all
    s = ShiftGenerator.new(users,workroles)
    # TODO  期間を渡す
    @result = s.generate()
    binding.pry
  end

  private
    def seeding
      user1 = User.create(name: "John",email: "John@furukido.local",password: "password")
      user2 = User.create(name: "Kevin",email: "Kevin@furukido.local",password: "password")
      user3 = User.create(name: "Cacy",email: "Cacy@furukido.local",password: "password")
      Attendance.create(date: Date.today, attendance_at: 10, leaving_at: 20,user_id: user1.id)
      Attendance.create(date: Date.today, attendance_at: 12, leaving_at: 22,user_id: user2.id)
      Attendance.create(date: Date.today, attendance_at: 18, leaving_at: 22,user_id: user3.id)
      workrole = WorkRole.create(name: "事務作業")
      req = [ 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 1 , 2 , 2 , 2 , 2 , 2 , 2 , 3 , 2 , 2 , 1 , 0 , 0 ] #0時〜23時
      req.each_with_index do |data, i|
        RequiredResource.create(what_day: 1, clock_at: i, count: data ,work_role_id: workrole.id)
      end
    end
end
