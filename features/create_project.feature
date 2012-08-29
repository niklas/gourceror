Feature: create a project
  In order to see my project animated
  I want to register it

  Background:
    Given I am signed in as admin user

  Scenario: adding it only by name
    Given I am on the admin dashboard
     When I follow "Projects"
     Then I should be on the admin projects page
     When I follow "New Project"
      And I fill in "Name" with "Honkaponka"
      And I press "Create"
     Then a project should exist with name: "Honkaponka"
