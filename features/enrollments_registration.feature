Feature: Patient Registration
  As a patient
  I want to submit registration info for a study
  So I can be registered for that study

  @Review[SQA]
  @Release2015.1.0
  @PB130359-001
  @Headed
  Scenario: A new iMedidata user should be able to register for a study
    When I fill in an activation code
    And I accept the TOU/DPN
    And I submit registration info for a new subject
    Then I should be registered for a study

  @Review[SQA]
  @Release2015.1.0
  @PB130361-001
  Scenario: An existing iMedidata user should be able to register for a study
    When I fill in an activation code
    And I accept the TOU/DPN
    And I submit registration info for an existing subject
    Then I should be registered for a study

  @Review[SQA]
  @Release2015.1.0
  @PB130359-002
  Scenario: A patient should not be able to register for a study if the Subject Service returns an error
    When I fill in an activation code
    And I accept the TOU/DPN
    And I submit registration info
    And the Subject Service returns an error
    Then I should see a representation of the error from Subject Service
