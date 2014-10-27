Feature: In order to use Web App
  I want to see list of all Medidations

  Background:
    Given I am an authorized user of the Web App
    And the following Medidations exist
      | Medidation   | Job Title         |
      | John Smith   | PRESIDENT         |
      | James Jones  | SOFTWARE_ENGINEER |
      | John Chaplin |                   |
      | John Doe     | VICE_PRESIDENT    |
      | Tony Smith   |                   |
    And I navigate to Medidations tab

  @Release2013.1.0
  @PB001
  @Validation
  Scenario: A user can see entire list of Medidations
    Then I see following Medidations
      | Medidation   | Job Title         |
      | John Smith   | PRESIDENT         |
      | James Jones  | SOFTWARE_ENGINEER |
      | John Chaplin |                   |
      | John Doe     | VICE_PRESIDENT    |
      | Tony Smith   |                   |
    And I should see "Edit" and "Delete" link besides each Medidation
    And I should see "Create Medidation" link on the page

  @Release2013.1.0
  @PB002
  @Draft
  Scenario: A user can view single Medidation record
    When I click on "John Smith"
    Then I should see the following details
      | Medidation | Job Title |
      | John Smith | PRESIDENT |
    And I should see "Back" link on the page

  @Release2013.1.0
  @PB003
  @Validation
  Scenario: A user can create Create Medidation record
    Given I click on "Create Medidation" link
    And I fill in fields with following values:
      | First Name | Last Name  | Job Title  |
      | New        | Medidation | PRESIDENT |
#    When I click on "Save" link
#    Then I should see success message "Medidation was successfully created."
#    And I should see "Create Medidation" in the list of records

  @Release2013.1.0
  @PB004
  @Draft
  Scenario: A user can edit a Medidation
    Given I click on "Edit" for "John Doe"
    And I enter "Change" in "Last Name"
    When I click on "Save" button
    Then I should see a success message "was successfully updated."
    And I should see "John Change"in the list of records

  @Release2013.1.0
  @PB005
  @Draft
  Scenario: A user can delete a Medidation after confirming a pop up question answer
    Given I click on "Delete" for "John Chaplin"
    And I see a pop up "Are you sure?"
    When I answer "Yes" to the pop up window question
    Then I should see a success message "Medidation was deleted successfully"
    And I should not see "John Chaplin" in the list of records


  # For the negative scenarios like manadatory information not filled in,
  #should there an error message be displayed
  #or the Save button remains disabled, and only gets enabled when all the required information is filled in?
  #Based on the response, the scenarios @PB006,@PB007,@PB008 will be updated
  @Release2013.1.0
  @PB006
  @Review[PM]
  @Draft
  Scenario: An error is thrown when user does not fill mandatory information while creating a new Medidation
    Given I click on "Create Medidation" link
    When I click on "Save" button
  # Update to the correct message later
    Then an error message should be displayed "Fill First and Last Name values"

  @Release2013.1.0
  @PB007
  @Review[PM]
  @Draft
  Scenario: An error is thrown when user does not fill all the required information while creating a new Medidation
    Given I click on "Create Medidation" link
    And I fill "First Name" with "ToCheck"
    When I click on "Save" button
    Then an error message should be displayed "Fill Last Name values"

  @Release2013.1.0
  @PB008
  @Review[PM]
  @Draft
  Scenario: An error is thrown when user does not fill all the required information while creating a new Medidation
    Given I click on "Create Medidation" link
    And I fill "Last Name" with "ToCheck"
    When I click on "Save" button
    Then an error message should be displayed "Fill First Name values"

  #While editing a record, will the user be displayed an error mentioning required information not filled?
  @Release2013.1.0
  @PB009
  @Review[PM]
  @Draft
  Scenario: While editing a Medidation, an error message is displayed when user does not fill required information
    Given I edit "John Doe"
    And I keep "Last Name" blank
    When I click on "Save" button
    Then I should see an error message "Last Name cannot be left blank."
