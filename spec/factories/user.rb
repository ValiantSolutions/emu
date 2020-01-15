
FactoryBot.define do
  factory :user do
    username { "John Smith" }
    email { "john@example.com" }
    approved { true }
    otp_required_for_login { false }
  end

  factory :db_user, class: User do
    username { "John Smith" }
    email { "mydb@user.com" }
    approved { true }
    password {'testing123!'}
    password_confirmation {'testing123!'}
    otp_required_for_login { false }
  end

  factory :admin_account, class: User do
    username { "Admin User" }
    email { "admin@user.com" }
    approved { true }
    password {'testing123!'}
    password_confirmation {'testing123!'}
    otp_required_for_login { false }
    admin { true }
  end
end