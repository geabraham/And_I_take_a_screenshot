Feature: Patient Registration
  As a patient
  I want to submit registration info for a study
  So I can be registered for that study

  @Draft
  @Release2015.1.0
  @PB130359-001
  @Headed
  Scenario: A new iMedidata user should be able to register for a study
    When I fill in an activation code
    And I accept the TOU/DPN
    And I enter my email
    And I enter a password
    And I enter a security question and answer
    And the request to create account is successful
    Then I should be registered for a study
    And I should see the download page

  @Draft
  @Release2015.1.0
  @PB130361-001
  @Headed
  Scenario: An existing iMedidata user should be able to register for a study
    When I fill in an activation code
    And I accept the TOU/DPN
    And I enter my email
    And I enter a password
    And I click submit
    And the request to submit is successful
    Then I should be registered for a study
    And I should see the download page

  @Draft
  @Release2015.1.0
  @PB130359-002
  @Headed
  Scenario: A patient should not be able to register for a study if the Subject Service returns an error
    When I fill in an activation code
    And I accept the TOU/DPN
    And I enter my email
    And I enter a password
    And I click submit
    And the Subject Service returns an error
    Then I should see a representation of the error from Subject Service
    And I should see the download page
