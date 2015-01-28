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
    And I submit registration info as a new subject
    And the request to create account is successful
    Then I should see a link to download the Patient Cloud app
    And I should be registered for a study

  @Review[ENG]
  @Release2015.1.0
  @PB130361-001
  @Headed
  Scenario: An existing iMedidata user should be able to register for a study
    When I fill in an activation code
    And I accept the TOU/DPN
    And I submit registration info as an existing subject
    And the request to submit is successful
    Then I should see a link to download the Patient Cloud app
    And I should be registered for a study

  @Review[SQA]
  @Release2015.1.0
  @PB130359-002
  @Headed
  Scenario: A patient should not be able to register for a study if the back-end service returns an error
    When I fill in an activation code
    And I accept the TOU/DPN
    And I submit registration info as a new subject
    And the back-end service returns an error
    Then I should see a representation of the error from back-end service
