Feature: create a project
  In order to see my project animated
  I want to register it

  Scenario: adding it only by name
    Given I am on the home page
     When I follow "New Project"
      And I fill in "Name" with "Honkaponka"
      And I press "Create"
     Then a project should exist with name: "Honkaponka"
      And I should be on the edit page for the project
