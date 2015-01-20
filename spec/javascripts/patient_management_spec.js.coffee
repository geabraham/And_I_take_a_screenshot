describe 'patient management select study and site form', ->
  studyUuid = 'fda08b50-9fe1-11df-a531-12313900d531'
  sitesUrl = '/patient_management/sites/' + studyUuid
  studySitesResponse =           
    status: 200
    contentType: 'application/json'
    responseText: JSON.stringify([['Nestle Research Center', 1], ['Japan Tobacco', 2]])

  beforeEach ->
    loadFixtures 'selectStudyAndSite.html'
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
        jasmine.Ajax.requests.mostRecent().response studySitesResponse
        expect($("#patient_management_study_site option").length).toBe 3

    describe 'when a user deselects a study', ->
      it 'clears the current options populated in the study sites drop down', ->
        $('#patient_management_study').val('').change()
        expect($('#patient_management_study_site option').length).toBe 1

  describe 'launch button', ->
    describe 'default', ->
      it 'is disabled', ->
        expect($('input#launch-patient-management')).toHaveAttr('disabled', 'disabled')
    
      it 'does not have an href property', ->
        expect($('a#launch-link')).not.toHaveAttr('href')
    
    describe 'when only study is selected', ->
      beforeEach ->
        $('#patient_management_study').val(studyUuid).change()

      it 'is disabled', ->
        expect($('input#launch-patient-management')).toHaveAttr('disabled', 'disabled')

      it 'does not have an href property', ->
        expect($('a#launch-link')).not.toHaveAttr('href')

    describe 'when both study and site options are selected', ->
      beforeEach ->
        $("#patient_management_study").val(studyUuid).change()
        jasmine.Ajax.requests.mostRecent().response studySitesResponse
        $('#patient_management_study_site').val(1).change()

      it 'is enabled', ->
        expect($('input#launch-patient-management')).not.toHaveAttr('disabled')

      it 'has the right href', ->
        expect($('a#launch-link').length).toBe 1

    describe 'when both study and site options are selected and then deselected', ->
      beforeEach ->
        $("#patient_management_study").val(studyUuid).change()
        jasmine.Ajax.requests.mostRecent().response studySitesResponse
        $('#patient_management_study_site').val(1).change()
        $("#patient_management_study").val('').change()

      it 'is disabled', ->
        expect($('input#launch-patient-management')).toHaveAttr('disabled', 'disabled')

      it 'does not have an href property', ->
        expect($('a#launch-link')).not.toHaveAttr('href')

  return
