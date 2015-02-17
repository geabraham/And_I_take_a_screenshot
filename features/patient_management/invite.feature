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
      | country | language | country_code | language_code |
      | USA     | English  | USA          | eng           |
      | USA     | Spanish  | USA          | spa           |
      | Canada  | English  | CAN          | eng           |
      | Canada  | French   | FRA          | fra           |
      | Israel  | Arabic   | ISR          | ara           |
      | Israel  | Hebrew   | ISR          | heb           |
    And the following subject names are avaible for site "DeepSpaceStation":
      | subject_identifier |
      | Subject001         |
      | Subject002         |
      | Subject003         |

  @Release2015.1.0
  @PB130799-001
  @Headed
  @Review[SQA]
  Scenario: As an authorized provider who has logged in, I am able to select a country/language pair and a subject name when inviting a new patient.
    Given I am logged in
    And I am authorized to manage patients for study "TestStudy001"
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
  Scenario: As an authorized provider who has logged in, an attempt to invite a patient is successful.
    Given I am logged in
    And I am authorized to manage patients for study "TestStudy001"
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    And I invite a user with the following attributes:
      | attribute_name   | attribute_value             |
      | initials         | LCD                         |
      | email            | lt-commander-data@mdsol.com |
      | subject          | Subject001                  |
      | country_language | Israel / Arabic             |
    # REVIEW: This is pending - should it be Review[SQA] or Review[ENG]?
    # Note: Pending patient management grid feature.
    #  In the intermediary, manual tests should check subjects database for expected objects and attributes.
    Then I should see a newly created patient enrollment for user LCD in the patient management grid with:
      | attribute_name  | attribute_value             |
      | state           | invited                     |
      | activation_code | <activation_code>           |
      | enrollment_type | in-person                   |
      | email           | lt-commander-data@mdsol.com |
    And the subject dropdown should get refreshed

  @Release2015.1.0
  @PB130799-003
  @Headed
  @Review[SQA]
  Scenario: As an authorized provider who has logged in, I am unable to invite a patient until all required attributes are provided.
    Given I am logged in
    And I am authorized to manage patients for study "TestStudy001"
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    And I select a subject but I don't select a country / language pair
    Then I am unable to invite a patient

  @Release2015.1.0
  @PB130799-004
  @Headed
  @Review[SQA]
  Scenario: As an authorized provider who has logged in, I see an error message when the backend service returns an error.
    Given I am logged in
    And I am authorized to manage patients for study "TestStudy001"
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    And I invite a user with all required attributes
    When the backend service returns an error response
    Then I should see an error message: "Subject not available. Please try again."
    And the subject dropdown should get refreshed

  @Realse2015.1.0
  @PB130799-005
  @Headed
  @Review[SQA]
  Scenario: As an authorized provider who has logged in, I see an error page when the backend does not respond.
    Given I am logged in
    And I am authorized to manage patients for study "TestStudy001"
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    And I invite a user with all required attributes
    When the backend service does not respond
    Then I should see an error message: "Service unavailable, please try again later."

  @Realse2015.1.0
  @PB130799-006
  @Headed
  @Review[SQA]
  Scenario: As an authorized provider who has logged in, I see a message when there are are no subjects available.
    Given I am logged in
    And I am authorized to manage patients for study "TestStudy001"
    And the request for available subjects for site "DeepSpaceStation" does not return any subjects
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    Then the only subject option should read "No subjects available"

  # REVIEW: We haven't covered the case where avaible subjects request gets a failed connection / service down error.
  #   Should we add scenario and functionality for service down when requesting available subjects?
  #
  @Realse2015.1.0
  @PB130799-007
  @Headed
  @Review[SQA]
  Scenario: As an authorized provider who has logged in, I see a message when a request for available subjects returns an error.
    Given I am logged in
    And I am authorized to manage patients for study "TestStudy001"
    And the request for available subjects for site "DeepSpaceStation" returns any error
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    Then the only subject option should read "No subjects available"

  @Release2015.1.0
  @PB130799-008
  @Headed
  @Review[SQA]
  Scenario: As a logged user with no patient management permissions, an attempt to access patient management fails.
    Given I am logged in
    When I navigate to patient management via a study and site
    Then I should see an error page with the message:
      | The link or URL you used either doesn't exist or you don't have permission to view it. |

  @Release2015.1.0
  @PB130799-009
  @Headed
  @Review[SQA]
  Scenario: As a user who is not logged in, an attempt to access patient management redirects to login.
    Given I am not logged in
    When I navigate to patient management via a study and site
    Then I should be redirected to the login page
