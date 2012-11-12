# spec/factories/contacts.rb

require 'faker'

FactoryGirl.define do
  factory :contact do |f|
    f.first_name { Faker::Name.first_name }
    f.last_name { Faker::Name.last_name }
    f.phone { Faker::PhoneNumber.phone_number }
    f.email { Faker::Internet.email }
  end
end

