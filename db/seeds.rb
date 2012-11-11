# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts 'Create Default Roles'
Role.create(:name => :admin)
Role.create(:name => :executive)
Role.create(:name => :manager)
Role.create(:name => :team_member)
Role.create(:name => :designer)
puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :first_name => 'First', :last_name => 'User', :email => 'user@example.com', :password => 'please', :password_confirmation => 'please'
puts 'New user created: ' << user.first_name
user2 = User.create! :first_name => 'Second', :last_name => 'User', :email => 'user2@example.com', :password => 'please', :password_confirmation => 'please'
puts 'New user created: ' << user2.first_name
user.add_role :admin
