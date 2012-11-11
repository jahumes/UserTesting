Feature: Edit User
  As a registered user of the website
  I want to edit my and other user profiles
  so I can change usernames

    Scenario: I sign in and edit my account
      Given I am logged in
      When I edit my account details
      Then I should see a personal account edited message

    Scenario: I sign in and edit another account
      Given I am logged in as admin
      When I edit another user account
      Then I should see an account edited message
