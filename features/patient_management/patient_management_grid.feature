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
    And patient cloud supports the following country / language pairs:
      | country | language | country_code | language_code |
      | Israel  | Hebrew   | ISR          | heb           |
    And the following subject names are available for site "DeepSpaceStation":
      | subject_identifier |
      | Subject003         |
    And I am logged in
   
  @Release2015.1.0
  @PB130352-001
  @Headed
  @Review[SQA]       
  Scenario: A provider should be able to view existing enrollments.
    Given I am authorized to manage patients for study "TestStudy001"
    And patient enrollments exist for "Subject001" and "Subject002"
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    And I take a screenshot
    Then I should see a row for each subject with an obscured email, an activation code, an invited status, a formatted date, subject and initials
    And I take a screenshot

  @Release2015.1.0
  @PB130352-002
  @Headed
  @Review[SQA] 
  Scenario: A provider views patient management grid when there are no patient enrollments.
    Given I am authorized to manage patients for study "TestStudy001"
    And no patient enrollments exist for site "DeepSpaceStation"
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    And I take a screenshot
    Then I should see a message saying "There are currently no patient enrollments for this study."
    And I take a screenshot

  @Draft
  @Release2015.1.0
  @PB146381-001
  @Headed
  @Review[ENG]
  Scenario: A provider views patient management grid when backend returns an error.
    Given I am authorized to manage patients for study "TestStudy001"
    And the request for patient enrollments returns an error 
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    And I take a screenshot
    #TODO figure out error message and localize
    Then I should see a message saying "<some error string>"
    And I take a screenshot

  @Release2015.1.0
  @PB130352-004
  @Headed
  @Review[ENG]
  Scenario: A provider should be able to page through a large number of enrollments.
    Given I am authorized to manage patients for study "TestStudy001"
    And 70 patient enrollments exist for site "DeepSpaceStation"
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    And I take a screenshot
    Then I should see that I am on page 1 of 3
    And 25 patient enrollments are displayed
    And I take a screenshot
    And patient enrollments are ordered by date
    And there is an active Next Page button
    And there is an inactive Previous Page button
    And I take a screenshot
                                          
