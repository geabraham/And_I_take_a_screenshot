Feature: Patient Registration
  As a patient
  I want to submit registration info for a study
  So I can be registered for that study

  @Review[ENG]
  @Release2015.1.0
  @PB130359-001
  @Headed
  @PatientFlow
  Scenario: A new iMedidata user should be able to register for a study
    When I fill in a valid activation code
    And I click the activate button
    Then I should see the "TOU_DPN" page
    And I accept the TOU/DPN
    Then I should see the "Email" page
    Then I enter email information for a new subject
    And I click on the next button
    Then I should see the "Password" page
    Then I enter password information for a new subject
    And I click on the next button
    Then I should see the "security questions" page
    Then I enter security question and answer for a new subject
    And the request to create account is successful
    Then I should see a link to download the Patient Cloud app
    And I should be registered for a study

  @Review[ENG]
  @Release2015.1.0
  @PB130359-002
  @Headed
  @PatientFlow
  Scenario: A patient should not be able to register for a study if the back-end service returns a user exists error
    When I fill in a valid activation code
    And I click the activate button
    And I accept the TOU/DPN
    And I submit registration info as a new subject
    And the back-end service returns an error "User already exists"
    Then I should see a representation of the error "User already exists" from back-end service

  @Review[ENG]
  @Release2015.1.0
  @PB138064-001
  @Headed
  @PatientFlow
  Scenario Outline: An invalid activation code displays an error message
    When I fill in an <validity> activation code
    And I click the activate button
    And the back-end service returns "<state>"
    Then I should see a representation of the error "<msg>" from back-end service
  Examples:
    |validity            |  msg                                         | state         |
    |   inactive         | Activation Code must be in active state        |inactive       |
    |   not_exist        | Response errors: Activation code not found..   |exception      |
    |   expired          | Response errors: Activation code not found..   |exception      |

  @Review[ENG]
  @Release2015.1.0
  @PB130359-003
  @Headed
  @PatientFlow
  Scenario: A new iMedidata user should be able to register for a study in a language other than english
    When I fill in a valid activation code with a language code of deu
    And I click the activate button
    And I accept the TOU/DPN
    And I submit registration info as a new subject
    And the request to create account is successful
    Then I should see a link to download the Patient Cloud app
    And I should be registered for a study

  @Review[ENG]
  @Release2015.1.0
  @PB130359-004
  @Headed
  @PatientFlow
  Scenario: An activation code with an invalid language code displays an error message
    When I fill in a inactive activation code with a language code of xxx
    And I click the activate button
    And the back-end service returns "inactive"
    Then I should see a representation of the error "Activation Code must be in active state" from back-end service
