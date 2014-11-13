@Draft
Feature: Activation Code Page
  As a patient
  I want to submit registration info for a study
  So I can be registered for that study
  
  @Draft
  @Release2015.1.0
  @PB130359-001
  Scenario: A patient should be able to register for a study
    When I fill in an activation code
    And I accept the TOU/DPN
    And I submit registration info
    Then I should be registered for a study

  @Draft
  @Release2015.1.0
  @PB130359-002
  Scenario: A patient should not be able to register for a study if the Patient Service returns an error
    When I fill in an activation code
    And I accept the TOU/DPN
    And I submit registration info
    And the Patient Service returns an error
    Then I should see a representation of the error from Patient Service
