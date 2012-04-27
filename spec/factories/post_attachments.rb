FactoryGirl.define do
  factory :post_attachment do
    post
    sequence(:filename) { |n| "test#{n}.txt" }
    content_type 'text/plain'
    data 'Just another plain-text test attachment.'
  end
end
