### UTILITY METHODS ###

def create_visitor
  @visitor ||= { :first_name => "Testy", :last_name => 'Userton', :email => "example@example.com",
    :password => "please", :password_confirmation => "please" }
end

def create_alt_visitor
  @alt_visitor ||= @visitor.merge(:email => "testing_now@example.com")
end

def create_alt_user
  create_alt_visitor
  delete_alt_user
  @alt_user = FactoryGirl.create(:user, email: @alt_visitor[:email])
end

def find_alt_user
  @alt_user ||= User.first conditions: {:email => @alt_visitor[:email]}
end

def find_user
  @alt_user ||= User.first conditions: {:email => @visitor[:email]}
end

def create_unconfirmed_user
  create_visitor
  delete_user
  sign_up
  visit '/logout'
end

def create_user
  create_visitor
  delete_user
  @user = FactoryGirl.create(:user, email: @visitor[:email])
end

def set_user_as_admin
  @user ||= User.first conditions: {:email => @visitor[:email]}
  admin_role = Role.find_by_name(:admin)
  @user.add_role(admin_role)
end

def delete_user
  @user ||= User.first conditions: {:email => @visitor[:email]}
  @user.destroy unless @user.nil?
end

def delete_alt_user
  @alt_user ||= User.first conditions: {:email => @alt_visitor[:email]}
  @alt_user.destroy unless @alt_user.nil?
end

def sign_up
  visit '/users/new'
  d { @alt_visitor }
  fill_in "user_first_name", :with => @alt_visitor[:first_name]
  fill_in "user_last_name", :with => @alt_visitor[:last_name]
  fill_in "Email", :with => @alt_visitor[:email]
  fill_in "Password", :with => @alt_visitor[:password]
  fill_in "Password confirmation", :with => @alt_visitor[:password_confirmation]
  click_button "Create User"
  find_alt_user
end

def sign_in
  visit '/'
  fill_in "input-username", :with => @visitor[:email]
  fill_in "input-password", :with => @visitor[:password]
  click_button "Login"
end

### GIVEN ###
Given /^I am not logged in$/ do
  visit '/logout'
end

Given /^I am logged in$/ do
  create_user
  sign_in
end

Given /^I am logged in as admin$/ do
  create_user
  set_user_as_admin
  sign_in
end

Given /^I exist as a user$/ do
  create_user
end

Given /^I do not exist as a user$/ do
  create_visitor
  delete_user
end

Given /^I exist as an unconfirmed user$/ do
  create_unconfirmed_user
end

### WHEN ###
When /^I sign in with valid credentials$/ do
  create_visitor
  sign_in
end

When /^I sign out$/ do
  visit '/logout'
end

When /^I create a user with valid user data$/ do
  create_alt_visitor
  sign_up
end

When /^I create a user with an invalid email$/ do
  create_alt_visitor
  @alt_visitor = @alt_visitor.merge(:email => "notanemail")
  sign_up
end

When /^I create a user with an existing email$/ do
  create_alt_user
  sign_up
end

When /^I create a user without a password confirmation$/ do
  create_alt_visitor
  @alt_visitor = @alt_visitor.merge(:password_confirmation => "")
  sign_up
end

When /^I create a user without a password$/ do
  create_alt_visitor
  @alt_visitor = @alt_visitor.merge(:password => "")
  sign_up
end

When /^I create a user with a mismatched password confirmation$/ do
  create_alt_visitor
  @alt_visitor = @alt_visitor.merge(:password_confirmation => "please123")
  sign_up
end

When /^I return to the site$/ do
  visit '/'
end

When /^I sign in with a wrong email$/ do
  @visitor = @visitor.merge(:email => "wrong@example.com")
  sign_in
end

When /^I sign in with a wrong password$/ do
  @visitor = @visitor.merge(:password => "wrongpass")
  sign_in
end

When /^I edit my account details$/ do
  click_link "Edit Account"
  fill_in "user_first_name", :with => "newname"
  click_button "Update User"
end

When /^I edit another user account$/ do
  create_alt_user
  visit edit_user_path(@alt_user)
  fill_in "user_first_name", :with => "newname"
  click_button "Update User"
end

When /^I look at the list of users$/ do
  visit users_path
end

### THEN ###
Then /^I should be signed in$/ do
  page.should have_content "Logout"
  page.should_not have_content "Sign up"
  page.should_not have_content "Login"
end

Then /^I should be signed out$/ do
  page.should have_content "Remember me"
  page.should have_selector "input#input-username"
  page.should have_selector "input#input-password"
  page.should have_selector "input[name=commit]"
  page.should_not have_content "Logout"
end

Then /^I see an unconfirmed account message$/ do
  page.should have_content "You have to confirm your account before continuing."
end

Then /^I see a successful sign in message$/ do
  page.should have_content "Signed in successfully."
end

Then /^I should see a successful create message$/ do
  page.should have_content "User Successfully Created!"
end

Then /^I should see an invalid email message$/ do
  page.should have_content "Emailis invalid"
end

Then /^I should see an existing email message$/ do
  page.should have_content "Emailhas already been taken"
end

Then /^I should see a missing password message$/ do
  page.should have_content "Passwordcan't be blank"
end

Then /^I should see a missing password confirmation message$/ do
  page.should have_content "Passworddoesn't match confirmation"
end

Then /^I should see a mismatched password message$/ do
  page.should have_content "Passworddoesn't match confirmation"
end

Then /^I should see a signed out message$/ do
  page.should have_content "Signed out successfully."
end

Then /^I see an invalid login message$/ do
  page.should have_content "Invalid email or password."
  page.should have_selector "div.alert-danger"
end

Then /^I should see an account edited message$/ do
  page.should have_content "User Successfully Updated!"
end

Then /^I should see a personal account edited message$/ do
  page.should have_content "You updated your account successfully!"
end

Then /^I should see my name$/ do
  create_user
  page.should have_content @user[:first_name]
end
