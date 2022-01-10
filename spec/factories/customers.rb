FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { '12345678' }

    factory :admin do
      role { :admin }
      sequence(:email) { |n| "email-#{n}@example.com" }
      password { '12345678' }
    end
  end
end
