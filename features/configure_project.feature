Feature: Configure Project
  In order to see my project animated
  I want to confige the source for its blubbelblabbel

  Background:
    Given I am signed in as admin user
      And a project exists with name: "Endless Loops"
      And I am on the page for the project
     When I follow "Edit"

  Scenario: give repository url
     When I fill in "Repository" with "git://github.com/anonymous/endless_loops"
      And I press "Update Project"
     Then the project's repository should be "git://github.com/anonymous/endless_loops"
      And I should see "git://github.com/anonymous/endless_loops"

  Scenario: upload log manually for private projects
    Given I should see "git log --pretty=format:user:%aN%n%ct --reverse --raw --encoding=UTF-8 --no-renames > history.log"
     When I attach the file "spec/fixtures/history.log" to "Log"
      And I press "Update Project"
     Then I should see "history.log"

