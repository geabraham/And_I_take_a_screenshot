@Draft
Feature: A provider can view the statuses of enrollments in a study
  As a provider
  I want to view the statuses of all of the enrollments in a study site
  So I can manage the enrollment process.

  Background:
    Given patient management is a part of the following studies:
      | name         |
      | TestStudy001 |
    And patient management is a part of the following sites:
      | study_name   | name                 |
      | TestStudy001 | DeepSpaceStation     |
    And patient cloud supports the following country / language pairs:
      | country | language |
      | USA     | English  |
    And the following subject names are avaible for site "DeepSpaceStation":
      | subject    |
      | Subject001 |
      | Subject002 |
   
  @Release2015.1.0
  @PB130352-001
  @Headed
  @Review[ENG]       
  Scenario: A provider should be able to view enrollment statuses:
    Given I am logged in
    And I am authorized to manage patients for study site "DeepSpaceStation" in study "TestStudy001"
    And a patient enrollment exists for Subject001
    And a patient enrollment exists for Subject002
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    Then I should see a row for Subject001
    And I should see a row for Subject002
   
  @Release2015.1.0
  @PB130352-002
  @Headed
  @Review[ENG] 
  Scenario: A provider views patient management grid when there are no patient enrollments:
    Given I am logged in
    And I am authorized to manage patients for study site "DeepSpaceStation" in study "TestStudy001"
    And I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    And there are 0 patient enrollments for study  "TestStudy001" and site "DeepSpaceStation"
    Then I should see a message saying 'There are currently no patient enrollments for this study'

  @Release2015.1.0
  @PB130352-003
  @Headed
  @Review[ENG]
  Scenario: A provider views patient management grid when backend returns an error:
    Given I am logged in
    And I am authorized to manage patients for study site "DeepSpaceStation" in study "TestStudy001"
    And I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    And the request for patient enrollments returns any error 
    Then I should see a message saying 'There are currently no patient enrollments for this study'

  @Release2015.1.0
  @PB130352-004
  @Headed
  @Review[ENG]
  Scenario: A provider should be able to page through a large number of enrollments:
    Given I am logged in
    And I am authorized to manage patients for study site "DeepSpaceStation" in study "TestStudy001"
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    And the number of items to show per page is 25
    And there are 70 patient enrollments for study  "TestStudy001" and site "DeepSpaceStation"
    Then I should see that I am on page 1 of 3
    And 25 patient enrollments are displayed
    And there is an active Next Page button
    And there is an inactive Previous Page button
                                          
