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
    When I enter a valid activation code
    And I submit the activation code
    Then I should see the "TOU/DPN" page
    And I accept the TOU/DPN
    Then I should see the "email" page
    Then I enter email information for a new subject
    And I submit "email" information
    Then I should see the "password" page
    Then I enter password information for a new subject
    And I submit "password" information
    Then I should see the "security questions" page
    Then I enter security question and answer for a new subject
    And the request to create account is successful
    Then I should see a link to download the Patient Cloud app
    And I should be registered for a study

  @Review[SQA]
  @Release2015.1.0
  @PB130359-002
  @Headed
  @PatientFlow
  Scenario: A patient should not be able to register for a study if the user email already exists
    When I enter a valid activation code
    And I submit the activation code
    And I accept the TOU/DPN
    And I submit registration info as a new subject
    And the back-end service returns an error "User already exists"
    Then I should see a representation of the error "User already exists" from the back-end service

  @Review[SQA]
  @Release2015.1.0
  @PB138064-001
  @Headed
  @PatientFlow
  Scenario Outline: An invalid activation code displays an error message
    When I enter an <validity> activation code
    And I submit the activation code
    And the back-end service returns "<state>"
    Then I should see a representation of the error "<msg>" from the back-end service
  Examples:
    |validity            |  msg                                           | state         |
    |   inactive         | Activation Code must be in active state        |inactive       |
    |   not_exist        | Response errors: Activation code not found.   |exception      |
    |   expired          | Response errors: Activation code not found.   |exception      |



  @Review[SQA]
  @Release2015.1.0
  @PB130359-003
  @Headed
  @PatientFlow
  Scenario: A new iMedidata user should be able to register for a study in a language other than english
    When I enter a valid activation code with a language code of deu
    And I submit the activation code
    And I accept the TOU/DPN
    And I submit registration info as a new subject
    And the request to create account is successful
    Then I should see a link to download the Patient Cloud app
    And I should be registered for a study

  @Review[SQA]
  @Release2015.1.0
  @PB130359-004
  @Headed
  @PatientFlow
  Scenario: An activation code with an invalid language code displays an error message
    When I enter a inactive activation code with a language code of xxx
    And I submit the activation code
    And the back-end service returns "inactive"
    Then I should see a representation of the error "Activation Code must be in active state" from the back-end service

  @Review[SQA]
  @Release2015.1.0
  @PB130359-005
  @Headed
  @PatientFlow
  Scenario: An activation that contains 1 or 0 should display an error message (e.g. Activation_Code:101010)
    Given I enter an incorrect activation code
    Then I should see a representation of the error "This code is incorrect. Contact your provider." from the form validation

  @Review[SQA]
  @Release2015.1.0
  @PB151748-001
  @Headed
  @PatientFlow
  Scenario: A user should be able to submit an activation code using the Enter key
    When I enter a valid activation code
    And I submit the activation code using the Enter key
    And I accept the TOU/DPN # this should also be tested with the Enter button, but for this step it fails on CI. why?
    Then I should see the "email" page
    Then I enter email information for a new subject
    And I submit "email" information using the Enter key
    Then I should see the "password" page
    Then I enter password information for a new subject 
    And I submit "password" information using the Enter key
    Then I should see the "security questions" page
    Then I enter security question and answer for a new subject
    And the request to create account is successful using the Enter key
    Then I should see a link to download the Patient Cloud app
    And I should be registered for a study
