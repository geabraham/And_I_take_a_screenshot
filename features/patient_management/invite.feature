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
    And I am logged in
    And no patient enrollments exist for site "DeepSpaceStation"

  @Release2015.1.0
  @PB130799-001
  @Headed
  @Review[SQA]
  Scenario: An authorized provider can select a country/language pair and a subject when inviting a new patient.
    Given I am authorized to manage patients for study "TestStudy001"
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    Then I should be able to select from the following country / language pairs:
      | pair             |
      | USA / English    |
      | USA / Spanish    |
      | Canada / English |
      | Canada / French  |
      | Israel / Arabic  |
      | Israel / Hebrew  |
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
    And I invite a user with the following attributes:
      | attribute_name   | attribute_value             |
      | initials         | LCD                         |
      | email            | lt-commander-data@mdsol.com |
      | subject          | Subject001                  |
      | country_language | Israel / Arabic             |
    Then I should see a row for "Subject001" with an obscured email, an activation code, an invited status, a formatted date, subject and initials
    And the subject dropdown should get refreshed

  @Release2015.1.0
  @PB130799-003
  @Headed
  @Review[SQA]
  Scenario: An authorized provider is unable to invite a patient until all required attributes are provided.
    Given I am authorized to manage patients for study "TestStudy001"
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    And I select a subject but I don't select a country / language pair
    Then I am unable to invite a patient

  @Release2015.1.0
  @PB130799-004
  @Headed
  @Review[SQA]
  Scenario: An authorized provider sees an error message when the backend service returns an error.
    Given I am authorized to manage patients for study "TestStudy001"
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    And I invite a user with all required attributes
    And the backend service returns an error response
    Then I should see an error message: "Subject not available. Please try again."
    And the subject dropdown should get refreshed

  @Release2015.1.0
  @PB130799-005
  @Headed
  @Review[SQA]
  Scenario: An authorized provider sees an error message when the backend does not respond.
    Given I am authorized to manage patients for study "TestStudy001"
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    And I invite a user with all required attributes
    And the backend service does not respond
    Then I should see an error message: "Service unavailable, please try again later."

  @Release2015.1.0
  @PB130799-006
  @Headed
  @Review[SQA]
  Scenario: An authorized provider sees an informative message when there are are no subjects available.
    Given I am authorized to manage patients for study "TestStudy001"
    And the request for available subjects for site "DeepSpaceStation" does not return any subjects
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    Then the only subject option should read "No subjects available"

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

  @Release2015.1.0
  @PB130799-008
  @Headed
  @Review[SQA]
  Scenario: A user attempts to access patient management sees an error page.
    When I navigate to patient management for a study site for which I am not authorized
    Then I should see an error page with the message:
      | The link or URL you used either doesn't exist or you don't have permission to view it. |

  @Release2015.1.0
  @PB130799-009
  @Headed
  @Review[SQA]
  Scenario: A user who is not logged in attempts to access patient management and is redirected to login.
    Given I am not logged in
    When I navigate to patient management for a study site for which I am not authorized
    Then I should be redirected to the login page
