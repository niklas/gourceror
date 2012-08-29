Feature: Configure Project
  In order to see my project animated
  I want to confige the source for its blubbelblabbel

  Background:
    Given I am signed in as admin user

  Scenario: give repository url
    Given a project exists with name: "Endless Loops"
      And I am on the admin projects page
     When I follow "Edit"
      And I fill in "Repository" with "git://github.com/anonymous/endless_loops"
      And I press "Update Project"
     Then the project's repository should be "git://github.com/anonymous/endless_loops"
