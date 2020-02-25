FactoryBot.define do
  factory :user do
    email { 'douglas@gmail.com' }
    password { '12345678' }
    role { 0 }
  end
end
