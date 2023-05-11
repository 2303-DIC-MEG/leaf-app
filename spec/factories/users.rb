FactoryBot.define do
  factory :user, class: User do
    name { "test" }
    email { "test@gmail.com" }
    password { "password" }
    password_confirmation { password }
    admin {true}
  end
  factory :second_user, class: User do
    name { 'test2' }
    email { 'test2@gmail.com' }
    password { "password" }
    password_confirmation { password }
    admin {false}
  end
end
