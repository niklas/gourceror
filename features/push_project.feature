Feature: Push project
  I want next

  Scenario: choose my project as next
    Given I am signed in as admin user
      And a project "mine" exists with name: "Endless Loops", play_count: 5
      And a project "other" exists with name: "Endless Loops", play_count: 3
      And I am on the page for the project "mine"
     When I follow "Next!"
     Then the project "mine"'s play_count should be 2
      And I should be on the page for the project "mine"
