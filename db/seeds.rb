# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

# users
CSV.foreach('db/csv/users.csv', headers: true) do |row|
  User.where(email: row['email']).first_or_create do |user|
    user.name = row['name']
    user.email = row['email']
    user.password = row['password']
    user.role = row['role'].to_i
  end
end

# work_roles
CSV.foreach('db/csv/work_roles.csv', headers: true) do |row|
  WorkRole.where(name: row['name']).first_or_create
end

# attendances
CSV.foreach('db/csv/attendances.csv', headers: true) do |row|
  Attendance.where(date: row['date'], user_id: row['user_id']).first_or_create do |attendance|
    attendance.attendance_at = row['attendance_at']
    attendance.leaving_at = row['leaving_at']
  end
end

# required_resources
CSV.foreach('db/csv/required_resources.csv', headers: true) do |row|
  RequiredResource.where(
    what_day: row['what_day'],
    clock_at: row['clock_at'],
    work_role_id: row['work_role_id']
  ).first_or_create do |wr|
    wr.count = row['count']
  end
end

# shifts
CSV.foreach('db/csv/shifts.csv', headers: true) do |row|
  Shift.where(
    shift_in_at: row['shift_in_at'],
    shift_out_at: row['shift_out_at'],
    user_id: row['user_id'],
    work_role_id: row['work_role_id']
  ).first_or_create
end
