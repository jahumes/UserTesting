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
      if( (n + 5)%5 == 0)
        user.add_role(:admin)
      elsif( (n + 4)%5 == 0 )
        user.add_role(:executive)
      elsif( (n + 3)%5 == 0 )
        user.add_role(:manager)
      elsif( (n + 2)%5 == 0 )
        user.add_role(:team_member)
      elsif( (n + 1)%5 == 0 )
        user.add_role(:designer)
      end
    end
  end
end