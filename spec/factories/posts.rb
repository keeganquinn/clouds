FactoryGirl.define do
  factory :post do
    user
    sequence(:code) { |n| "test#{n}" }
    subject 'Test'
    body 'Just a test.'
  end
end
