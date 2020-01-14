start = DateTime.new(2020, 1, 1)
finish = DateTime.new(2020, 1, 10)
# Admin User
if Rails.env.development?
  User.where(email: 'admin@namba').first_or_create do |user|
    user.name = 'シフト職人'
    user.password = 'adminpass'
    user.password_confirmation = 'adminpass'
    user.role = 1
  end
end
# Normal User
users = []
attendances = []
50.times do |i|
  user = User.create(
    name: Faker::Name.last_name,
    email: Faker::Internet.free_email,
    password: Faker::Internet.password(min_length: 8)
  )

  time_array = [rand(24),rand(24)].sort
  (start..finish).each do |this_day|
    attendances << Attendance.new(date: this_day, attendance_at: time_array[0], leaving_at: time_array[1],user_id: user.id)
  end
end
Attendance.import! attendances

requiredresources = []
4.times do |n|
  workrole = WorkRole.create!(name: Faker::Company.name)
  req = ([0] * 24).map{ |x| rand(10) }.sort.rotate(rand(24)) #0時〜23時
  req.each_with_index do |data, i|
    (start..finish).each do |this_day|
      requiredresources << RequiredResource.new(what_day: RequiredResource.on_(this_day), clock_at: i, count: data ,work_role_id: workrole.id)
    end
  end
end
RequiredResource.import! requiredresources
