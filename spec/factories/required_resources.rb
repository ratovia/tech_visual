FactoryBot.define do
  factory :required_resource do
    what_day {Faker::Number.within(range: 1..14)}
    clock_at {Faker::Number.within(range: 0..23)}
    count    {Faker::Number.within(range: 1..15)}
    work_role
  end
end
