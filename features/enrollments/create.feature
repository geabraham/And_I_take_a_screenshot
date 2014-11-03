@Draft
Feature: Activation Code Page
  As a patient
  I want to submit registration info for a study
  So I can be enrolled in that study
  
  @Release2015.1.0
  @Draft
  Scenario: A patient should be able to visit the activation code page.
    When I visit the activation code page
    Then I should be on the activation code page
    