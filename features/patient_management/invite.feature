Feature: A provider can invite a user to participate in a study
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
      | country | language | country_code | language_code |
      | USA     | English  | USA          | eng           |
      | USA     | Spanish  | USA          | spa           |
      | Canada  | English  | CAN          | eng           |
      | Canada  | French   | FRA          | fra           |
      | Israel  | Arabic   | ISR          | ara           |
      | Israel  | Hebrew   | ISR          | heb           |
    And the following subject names are available for site "DeepSpaceStation":
      | subject_identifier |
      | Subject001         |
      | Subject002         |
      | Subject003         |
    And no patient enrollments exist for site "DeepSpaceStation"

  @Release2015.1.0
  @PB130799-001
  @Headed
  @Review[SQA]
  Scenario: An authorized provider can select a country/language pair and a subject when inviting a new patient.
    Given I am authorized to manage patients for study "TestStudy001"
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    And I take a screenshot
    Then I should be able to select from the following country / language pairs:
      | pair             |
      | USA / English    |
      | USA / Spanish    |
      | Canada / English |
      | Canada / French  |
      | Israel / Arabic  |
      | Israel / Hebrew  |
    And I take a screenshot
    And I should be able to select from the following subjects:
      | subject    |
      | Subject001 |
      | Subject002 |
      | Subject003 |

  @Release2015.1.0
  @PB130799-002
  @Headed
  @Review[SQA]
  Scenario: An authorized provider is able to invite a patient.
    Given I am authorized to manage patients for study "TestStudy001"
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    And I take a screenshot
    When I invite a user with the following attributes:
      | attribute_name   | attribute_value             |
      | initials         | LCD                         |
      | subject          | Subject001                  |
      | country_language | Israel / Arabic             |
    And I take a screenshot
    Then I should see a row for "Subject001" with an obscured email, an activation code, an invited status, a formatted date, subject and initials
    And the subject dropdown should get refreshed
    And I take a screenshot

  @Release2015.1.0
  @PB130799-003
  @Headed
  @Review[SQA]
  Scenario: An authorized provider is unable to invite a patient until all required attributes are provided.
    Given I am authorized to manage patients for study "TestStudy001"
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    And I take a screenshot
    And I select a subject but I don't select a country / language pair
    And I take a screenshot
    Then I am unable to invite a patient
    And I take a screenshot

  @Release2015.1.0
  @PB130799-004
  @Headed
  @Review[SQA]
  Scenario: An authorized provider sees an error message when subject is already registered.
    Given I am authorized to manage patients for study "TestStudy001"
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    And I take a screenshot
    When I invite a user with all required attributes
    And I take a screenshot
    And the backend service returns an error response due to subject id already existing
    Then I should see an error message: "Subject not available. Please try again."
    And I take a screenshot
    And the subject dropdown should get refreshed


  @Release2015.1.0
  @PB130799-005
  @Headed
  @Review[SQA]
  Scenario: An authorized provider sees an error message when imedidata/subject service is down.
    Given I am authorized to manage patients for study "TestStudy001"
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    And I take a screenshot
    When I invite a user with all required attributes
    And I take a screenshot
    And the backend service does not respond due to imedidata or subject service being down
    Then I should see an error message: "Service unavailable, please try again later."
    And I take a screenshot

  @Release2015.1.0
  @PB130799-006
  @Headed
  @Review[SQA]
  Scenario: An authorized provider sees an informative message when there are are no subjects available.
    Given I am authorized to manage patients for study "TestStudy001"
    And I take a screenshot
    And the request for available subjects for site "DeepSpaceStation" does not return any subjects
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    Then the only subject option should read "No subjects available"
    And I take a screenshot

  # REVIEW: We haven't covered the case where available subjects request gets a failed connection / service down error.
  #   Should we add scenario and functionality for service down when requesting available subjects?
  #
  @Release2015.1.0
  @PB130799-007
  @Headed
  @Review[SQA]
  Scenario: An authorized provider sees an informative message when a request for available subjects returns an error.
    Given I am authorized to manage patients for study "TestStudy001"
    And the request for available subjects for site "DeepSpaceStation" returns any error
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    Then the only subject option should read "No subjects available"
    And I take a screenshot

  @Release2015.1.0
  @PB130799-008
  @Headed
  @Review[SQA]
  Scenario: A unauthorized user attempts to access patient management sees an error page.
    Given I am logged in but not authorized to access a study site
    When I navigate to patient management for a study site by directly placing the url in the browser
    Then I should see an error page with the message:
      | The link or URL you used either doesn't exist or you don't have permission to view it. |
    And I take a screenshot

  @Release2015.1.0
  @PB130799-009
  @Headed
  @Review[SQA]
  Scenario: A user who is not logged in attempts to access patient management and is redirected to login.
    Given I am not logged in
    When I navigate to patient management for a study site by directly placing the url in the browser
    Then I should be redirected to the login page
    And I take a screenshot
