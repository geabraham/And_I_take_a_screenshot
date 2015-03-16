Feature: Patient Management Study Site Selection
  As a provider
  I want to select a study and a site
  So I can navigate to the patient management table
  And manage patients

  Background:
    Given patient management is a part of the following studies:
      | name         |
      | TestStudy001 |
      | TestStudy002 |
      | TestStudy003 |
    And patient management is a part of the following sites:
      | study_name   | name                 | 
      | TestStudy001 | DeepSpaceStation     |
      | TestStudy001 | GalacticQuadrantBeta |
      | TestStudy002 | GenesisPlanet        |
      | TestStudy003 | StarfleetAcademy     |

  @Validation
  @Release2015.1.0
  @PB130363-001
  @Headed
  Scenario: An authorized patient management user who is logged in navigates to the study site selection page and can select a study and site.
    Given I am logged in
    And I am authorized to manage patients for studies "TestStudy001, TestStudy002"
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
    When I select "DeepSpaceStation" from the list of sites
    Then I should see an active launch button

  @Validation
  @Release2015.1.0
  @PB130363-002
  @Headed
  Scenario: An authorized patient management user who is logged in navigates to the study site selection page in the context of a study only needs to select a site.
    Given I am logged in
    And I am authorized to manage patients for studies "TestStudy001, TestStudy002"
    When I navigate to patient management via study "TestStudy001" in iMedidata
    Then I should see "TestStudy001" pre-selected in the list of studies
    And I should see a list of sites:
      | name                 |
      | DeepSpaceStation     |
      | GalacticQuadrantBeta |
    When I select "GalacticQuadrantBeta" from the list of sites
    Then I should see an active launch button

  @Validation
  @Release2015.1.0
  @PB130363-003
  @Headed
  Scenario: An unauthorized patient management user who is logged in tries to navigate to the study site selection page is shown a helpful error message.
    Given I am logged in
    When I navigate to patient management via the apps pane in iMedidata
    Then I should see a not found error page

  @Validation
  @Release2015.1.0
  @PB130363-004
  @Headed
  Scenario: A user who is not logged in and tries to navigate to the patient management study site selection page is redirected to login.
    Given I am not logged in
    When I navigate to patient management by directly placing the url in the browser
    Then I should be redirected to the login page
