describe 'patient management select study and site form', ->
  beforeEach ->
    loadFixtures 'patient_management/selectStudyAndSite.html'
    jasmine.Ajax.install()

  afterEach ->
    jasmine.Ajax.uninstall()

  describe 'study site drop down options', ->
    describe 'when user selects a study', ->
      it 'makes a request to sites', ->
        $('#patient_management_study').val('fda08b50-9fe1-11df-a531-12313900d531').change()
        expect(jasmine.Ajax.requests.mostRecent().url).toBe "/patient_management/sites/fda08b50-9fe1-11df-a531-12313900d531"

      it 'clears the current options populated', ->
        $('#patient_management_study').val('').change()
        expect($('#patient_management_study_site option').length).toBe 1
  #     it 'populates with study sites returned from ajax call'

  # describe 'launch button', ->
  #   describe 'when study, site or both study and site options are unselected', ->
  #     it 'is disabled'
  #   describe 'when both study and site options are selected', ->
  #     it 'is enabled'
  return