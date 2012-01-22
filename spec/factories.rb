FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@cloudscontrol.us" }
    sequence(:username) { |n| "test#{n}" }
    password 't3st1ng'
    password_confirmation 't3st1ng'
    confirmed_at Time.now
  end

  factory :post do
    user
    sequence(:code) { |n| "test#{n}" }
    subject 'Test'
    body 'Just a test.'
  end
end
