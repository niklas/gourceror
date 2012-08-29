unless defined?(FactoryGirl::Password)
  FactoryGirl::Password = 'secret'
end
FactoryGirl.define do
  factory :admin_user do
    sequence(:email) {|i| "user-#{i}@gourceror.local"}
    password FactoryGirl::Password
    password_confirmation FactoryGirl::Password
  end
end
