require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    50.times do |n|
      first_name  = Faker::Name.first_name
      last_name = Faker::Name.last_name
      email = Faker::Internet.email
      password = 'please'
      password_confirmation = 'please'
      user = User.create!(:first_name => first_name,
                    :last_name => last_name,
                    :email => email,
                    :password => password,
                    :password_confirmation => password_confirmation)
      if( n%2 == 0)
        user.add_role(:admin)
      end
    end
  end
end