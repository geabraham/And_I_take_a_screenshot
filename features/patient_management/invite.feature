@Draft
Feature: A provider can invite a user to particpate in a study
  As a provider
  I want to invite patients to a study and study site
  So they can use the patient cloud

  Background:
    Given patient management is a part of the following studies:
      | name         |
      | TestStudy001 |
    And patient management is a part of the following sites:
      | study_name   | name                 |
      | TestStudy001 | DeepSpaceStation     |
      | TestStudy001 | GalacticQuadrantBeta |
    And patient cloud supports the following country / language pairs:
      | country | language |
      | USA     | English  |
      | USA     | Spanish  |
      | Canada  | English  |
      | Canada  | French   |
      | Israel  | Arabic   |
    And the following subject names are avaible for site "DeepSpaceStation":
      | subject_name |
      | Subject001   |
      | Subject002   |
      | Subject003   |

  @Release2015.1.0
  @PB130799-001
  @Headed
  Scenario: As an authorized provider who has logged in, I am able to select a country/language pair and a subject name when enrolling a new patient.
    Given I am logged in
    And I am authorized to manage patients for study site "DeepSpaceStation" in study "TestStudy001"
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    Then I should be able to select from the following country / language pairs:
      | pair              |
      | USA / English     |
      | USA / Spanish     |
      | Canada / English  |
      | Canada / French   |
      | Israel / Arabic   |
    And I should be able to select from the following subject names:
      | subject_name |
      | Subject001   |
      | Subject002   |
      | Subject003   |

  @Release2015.1.0
  @PB130799-002
  @Headed
  Scenario: As an authorized provider who has logged in, an attempt to invite a patient is successful.
    Given I am logged in
    And I am authorized to manage patients for study site "DeepSpaceStation" in study "TestStudy001"
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    And I invite a user with the following attributes:
      | attribute_name   | attribute_value             |
      | initials         | LCD                         |
      | email            | lt-commander-data@mdsol.com |
      | subject_name     | Subject001                  |
      | country_language | Israel / Arabic             |
    # TODO: Double check this field defaulting to in-person for this flow.
    # TODO: Request UI of success message.
    #
    Then I should see a newly created patient enrollment for user LCD with state invited and enrollment type in-person

  @Release2015.1.0
  @PB130799-003
  @Headed
  Scenario: As an authorized provider who has logged in, an attempt to invite a patient fails when a required attribute is missing.
    Given I am logged in
    And I am authorized to manage patients for study site "DeepSpaceStation" in study "TestStudy001"
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    And I invite a user with the following attributes:
      | attribute_name   | attribute_value             |
      | initials         | LCD                         |
      | email            | lt-commander-data@mdsol.com |
      | subject_name     | Subject001                  |
    Then I should see an error message "Please select a Country/Language pair."

  @Release2015.1.0
  @PB130799-004
  @Headed
  Scenario: As a logged user with no patient management permissions, an attempt to access patient management fails.
    Given I am logged in
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    # TODO: Standardize this language and revise in `select_study_and_site` feature
    #
    Then I should see an error message "There doesn't seem to be anything here."

  @Release2015.1.0
  @PB130799-005
  @Headed
  Scenario: As a user who is not logged in, an attempt access patient management redirects to login.
    Given I am not logged in
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    Then I should be redirected to the login page
