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

      it 'clears the current options populated in the study sites drop down', ->
        $('#patient_management_study').val(studyUuid).change()
        expect($('#patient_management_study_site option').length).toBe 1

      it 'populates the study sites drop down when study sites are returned', ->
        $("#patient_management_study").val(studyUuid).change()
        jasmine.Ajax.requests.mostRecent().response
          status: 200
          contentType: 'application/json'
          responseText: JSON.stringify([['Nestle Research Center', 1], ['Japan Tobacco', 2]])
        expect($("#patient_management_study_site option").length).toBe 3

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