# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name: 'シフト職人' ,email: 'admin@namba', password: 'adminpass', password_confirmation: 'adminpass', role: 1) if Rails.env.development?
user1 = User.create(name: "John",email: "John@furukido.local",password: "password")
user2 = User.create(name: "Kevin",email: "Kevin@furukido.local",password: "password")
user3 = User.create(name: "Cacy",email: "Cacy@furukido.local",password: "password")
Attendance.create(date: Time.current, attendance_at: 10, leaving_at: 20,user_id: user1.id)
Attendance.create(date: Time.current, attendance_at: 12, leaving_at: 22,user_id: user2.id)
Attendance.create(date: Time.current, attendance_at: 18, leaving_at: 22,user_id: user3.id)
workrole = WorkRole.create(name: "事務作業")
req = [ 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 1 , 1 , 2 , 2 , 2 , 2 , 2 , 2 , 3 , 2 , 2 , 1 , 0 , 0 ] #0時〜23時
req.each_with_index do |data, i|
  RequiredResource.create(what_day: RequiredResource.on_(Time.current), clock_at: i, count: data ,work_role_id: workrole.id)
end