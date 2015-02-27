@Draft
Feature: A provider can view patient enrollments in a study
  As a provider
  I want to view the all of the patient enrollments in a study site
  So I can manage the enrollment process.

  Background:
    Given patient management is a part of the following studies:
      | name         |
      | TestStudy001 |
    And patient management is a part of the following sites:
      | study_name   | name                 |
      | TestStudy001 | DeepSpaceStation     |
   
  @Release2015.1.0
  @PB130352-001
  @Headed
  @Review[ENG]       
  Scenario: A provider should be able to view enrollment statuses.
    Given I am logged in
    And I am authorized to manage patients for study site "DeepSpaceStation" in study "TestStudy001"
    And a patient enrollment exists for Subject001
    And a patient enrollment exists for Subject002
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    Then I should see a row for Subject001 with an obscured email, an activation code, an inactive status, a formatted date, subject and initials
    And I should see a row for Subject002 with an obscured email, an activation code, an inactive status, a formatted date, subject and initials
   
  @Release2015.1.0
  @PB130352-002
  @Headed
  @Review[ENG] 
  Scenario: A provider views patient management grid when there are no patient enrollments.
    Given I am logged in
    And I am authorized to manage patients for study site "DeepSpaceStation" in study "TestStudy001"
    And there are 0 patient enrollments for study  "TestStudy001" and site "DeepSpaceStation"
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    Then I should see a message saying "There are currently no patient enrollments for this study"

  @Release2015.1.0
  @PB130352-003
  @Headed
  @Review[ENG]
  Scenario: A provider views patient management grid when backend returns an error.
    Given I am logged in
    And I am authorized to manage patients for study site "DeepSpaceStation" in study "TestStudy001"
    And the request for patient enrollments returns any error 
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    #TODO figure out error message and localize
    Then I should see a message saying "<some error string>"

  @Release2015.1.0
  @PB130352-004
  @Headed
  @Review[ENG]
  Scenario: A provider should be able to page through a large number of enrollments.
    Given I am logged in
    And I am authorized to manage patients for study site "DeepSpaceStation" in study "TestStudy001"
    And there are 70 patient enrollments for study  "TestStudy001" and site "DeepSpaceStation"
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    Then I should see that I am on page 1 of 3
    And 25 patient enrollments are displayed
    And patient enrollments are ordered by date
    And there is an active Next Page button
    And there is an inactive Previous Page button
                                          
