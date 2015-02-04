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
  Scenario: As an authorized provider who has logged in, I am able to select a country/language pair and a subject name when inviting a new patient.
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
    # QUESTION: Subject Name or Subject Identifier?
    #
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
    # NOTE: This is pending patient management grid.
    #
    Then I should see a newly created patient enrollment for user LCD in the patient management grid with:
      | attribute       | value                       |
      | state           | invited                     |
      | activation_code | <activation_code>           |
      | enrollment_type | in-person                   |
      | email           | lt-commander-data@mdsol.com |

  # QUESTION: What are the expectations for form validations?
  #   Before user data is submitted, what should be validated and what should failures look like?
  #
  @Release2015.1.0
  @PB130799-003
  @Headed
  Scenario: As an authorized provider who has logged in, an attempt to invite a patient fails when a required attribute is missing.
    Given I am logged in
    And I am authorized to manage patients for study site "DeepSpaceStation" in study "TestStudy001"
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    And I invite a user with required attributes except a country / language pair
    Then I should see an error message "Please select a Country / Language pair."

  # NOTE: New.
  @Realse2015.1.0
  @PB130799-004
  @Headded
  Scenario: As an authorized provider who has logged in, an attempt to invite a patient fails when the backend service returns an error.
    Given I am logged in
    And I am authorized to manage patients for study site "DeepSpaceStation" in study "TestStudy001"
    When I navigate to patient management via study "TestStudy001" and site "DeepSpaceStation"
    And I invite a user with all required attributes
    When the backend service returns an error
    # Question: Send to error page or message on the page?
    Then I should see an error page with the message:
      | <backend_service_error_message> |

  @Release2015.1.0
  @PB130799-005
  @Headed
  Scenario: As a logged user with no patient management permissions, an attempt to access patient management fails.
    Given I am logged in
    When I navigate to patient management via a study and site
    # TODO: Revise `select_study_and_site` feature to match this.
    #
    Then I should see an error page with the message:
      | The link or URL you used either doesn't exist or you don't have permission to view it. |

  @Release2015.1.0
  @PB130799-006
  @Headed
  Scenario: As a user who is not logged in, an attempt to access patient management redirects to login.
    Given I am not logged in
    When I navigate to patient management via a study and site
    Then I should be redirected to the login page
