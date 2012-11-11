Feature: Create
  In order to get access to protected sections of the site
  As a user
  I want to be able to create

    Background:
      Given I am logged in as admin

    Scenario: I a create user with valid data
      When I create a user with valid user data
      Then I should see a successful create message

  Scenario: I create a user with an existing email
    When I create a user with an existing email
    Then I should see an existing email message

  Scenario: I create a user with invalid email
      When I create a user with an invalid email
      Then I should see an invalid email message

    Scenario: I create a user without password
      When I create a user without a password
      Then I should see a missing password message

    Scenario: I create a user without password confirmation
      When I create a user without a password confirmation
      Then I should see a missing password confirmation message

    Scenario: I create a user with mismatched password and confirmation
      When I create a user with a mismatched password confirmation
      Then I should see a mismatched password message
