@Draft
Feature: Patient Management Study Site Selection
  As a provider
  I want to select a study and a site
  So I can navigate to the patient management table
  And manage patients

  Background:
    Given the following studies exist:
      | name         |
      | TestStudy001 |
      | TestStudy002 |
      | TestStudy003 |
    And the following sites exist:
      | study_name   | name                 | 
      | TestStudy001 | DeepSpaceStation     |
      | TestStudy001 | GalacticQuadrantBeta |
      | TestStudy002 | GenesisPlanet        |
      | TestStudy003 | StarfleetAcademy     |
    And a user with login "lt-commander-data@gmail.com" is a provider for studies "TestStudy001, TestStudy002"
    And a user with login "lt-worf@gmail.com" exists

  @Review[ENG]
  @Release2015.1.0
  @PB130363-001
  @Headed
  Scenario: An authorized user navigates to the study site selection page and can select a study and site
    Given I am a user with login "lt-commander-data@gmail.com"
    When I navigate to patient management via the apps pane in iMedidata
    Then I should see a list of studies:
      | name         |
      | TestStudy001 |
      | TestStudy002 |
    When I select "TestStudy001" from the list of studies
    Then I should see a list of sites:
      | name                 |
      | DeepSpaceStation     |
      | GalacticQuadrantBeta |
    When I select "DeepSpaceStation"
    Then I should be able to navigate to the patient management table

  @Review[ENG]
  @Release2015.1.0
  @PB130363-002
  @Headed
  Scenario: An authorized user navigates to the study site selection page in the context of a study only needs to select a site
    Given I am a user with login "lt-commander-data@gmail.com"
    When I navigate to patient management via study "Test001" in iMedidata
    Then I should see "TestStudy001" pre-selected in the list of studies
    And I should see a list of sites:
      | name                 |
      | DeepSpaceStation     |
      | GalacticQuadrantBeta |
    When I select "GalacticQuadrantBeta"
    Then I should be able to navigate to the patient management table

  @Review[ENG]
  @Release2015.1.0
  @PB130363-003
  @Headed
  Scenario: An unauthorized user tries to navigate to the study site selection page is shown a helpful error message.
    Given I am a user with login "lt-worf@gmail.com"
    When I navigate to patient management via the apps pane in iMedidata
    Then I should see the message "You are not authorized for patient management."

  @Review[ENG]
  @Release2015.1.0
  @PB130363-004
  @Headed
  Scenario: A random user tries to navigate to the study site selection page is redirected to iMedidata.
    Given I am a random user
    When I navigate to patient management via the apps pane in iMedidata
    Then I should be redirected to iMedidata
