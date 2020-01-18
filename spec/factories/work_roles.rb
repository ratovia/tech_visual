FactoryBot.define do
  factory :work_role do
    name {Faker::Job.title}

    trait :with_all_required_resources do
      after(:build) do |wr|
        what_days = 1..14
        clocks = 0..23
        what_days.each do |wd|
          clocks.each do |clock_at|
            create(:required_resource,
              what_day: wd,
              clock_at: clock_at,
              work_role: wr
            )
          end
        end
      end
    end
  end
end
