describe 'patient management select study and site form', ->
  studyUuid = 'fda08b50-9fe1-11df-a531-12313900d531'
  sitesUrl = '/patient_management/sites/' + studyUuid

  beforeEach ->
    loadFixtures 'patient_management/selectStudyAndSite.html'
    jasmine.Ajax.install()

  afterEach ->
    jasmine.Ajax.uninstall()

  describe 'study site drop down options', ->
    describe 'when user selects a study', ->
      it 'makes a request to sites', ->
        $('#patient_management_study').val(studyUuid).change()
        expect(jasmine.Ajax.requests.mostRecent().url).toBe sitesUrl

      it 'clears the current options populated', ->
        $('#patient_management_study').val(studyUuid).change()
        $('#patient_management_study').val('').change()
        expect($('#patient_management_study_site option').length).toBe 1

      it 'calls readyForLaunch', ->
        readyForLaunch = spyOn(window, 'readyForLaunch')
        $('#patient_management_study').val(studyUuid).change()
        expect(readyForLaunch.calls.count()).toEqual(1)

  describe 'populateStudySitesDropdown', ->
    it 'populates with study sites returned from ajax call', ->
      studySites = [['Nestle Research Center', 1],['Japan Tobacco Inc', 2]]
      clearPopulatedStudySites()
      populateStudySitesDropdown(studySites)
      expect($('#patient_management_study_site option').length).toBe 3

  describe 'launch button', ->
    describe 'default', ->
      it 'is disabled', ->
        expect($('input#launch-patient-management')).toHaveAttr('disabled', 'disabled')

    describe 'when study, site or both study and site options are unselected', ->
      it 'is disabled', ->
        $('#patient_management_study').val(studyUuid).change()
        expect($('input#launch-patient-management')).toHaveAttr('disabled', 'disabled')

    # TODO: Add me
    describe 'when both study and site options are selected', ->
      it 'is enabled', ->

  return