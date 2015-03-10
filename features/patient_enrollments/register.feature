Feature: Patient Registration
  As a patient
  I want to submit registration info for a study
  So I can be registered for that study

  @Review[SQA]
  @Release2015.1.0
  @PB130359-001
  @Headed
  @PatientFlow
  Scenario: A new iMedidata user should be able to register for a study
    When I fill in a valid activation code
    And I accept the TOU/DPN
    And I submit registration info as a new subject
    And the request to create account is successful
    Then I should see a link to download the Patient Cloud app
    And I should be registered for a study
 
  @Review[ENG]
  @Release2015.1.0
  @PB130361-001
  @Headed
  @PatientFlow
  Scenario: An existing iMedidata user should be able to register for a study
    When I fill in a valid activation code
    And I accept the TOU/DPN
    And I submit registration info as an existing subject
    And the request to submit is successful
    Then I should see a link to download the Patient Cloud app
    And I should be registered for a study

  @Review[SQA]
  @Release2015.1.0
  @PB130359-002
  @Headed
  @PatientFlow
  Scenario: A patient should not be able to register for a study if the back-end service returns an error
    When I fill in a valid activation code
    And I accept the TOU/DPN
    And I submit registration info as a new subject
    And the back-end service returns an error
    Then I should see a representation of the error from back-end service

  @Review[SQA]
  @Release2015.1.0
  @PB138064-001
  @Headed
  @PatientFlow
  Scenario: An invalid activation code displays an error message
    When I fill in an invalid activation code
    Then I should see a representation of the error from back-end service

  @Review[SQA]
  @Release2015.1.0
  @PB130359-001
  @Headed
  @PatientFlow
  Scenario: A new iMedidata user should be able to register for a study in a language other than english
    When I fill in a valid activation code with a language code of deu
    And I accept the TOU/DPN
    And I submit registration info as a new subject
    And the request to create account is successful
    Then I should see a link to download the Patient Cloud app
    And I should be registered for a study

  @Review[SQA]
  @Release2015.1.0
  @PB130359-001
  @Headed
  @PatientFlow
  Scenario: An activation code with an invalid language code displays an error message
    When I fill in a invalid activation code with a language code of xxx
    Then I should see a representation of the error from back-end service

  @Review[SQA]
  @Release2015.1.0
  @PB151748-001
  @Headed
  @PatientFlow
  Scenario: A new iMedidata user should be able to navigate through the registration flow using the Enter key
    When I fill in a valid activation code and press Enter
    And I accept the TOU/DPN using the Enter key
    And I submit registration info as a new subject using the Enter key
    And the request to create account is successful using the Enter key
    Then I should see a link to download the Patient Cloud app
    And I should be registered for a study
