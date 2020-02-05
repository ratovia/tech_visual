FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Devise.friendly_token }
    role { 'employee' }
  end
end
