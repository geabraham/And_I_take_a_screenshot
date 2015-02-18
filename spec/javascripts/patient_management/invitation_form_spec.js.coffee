describe 'patient management invitation form', ->
  subject = 'Subject-000'
  countryLanguagePair = "{'language_code':'ara','country_code':'ISR'}"
  study_uuid = 'fda08b50-9fe1-11df-a531-12313900d531'
  study_site_uuid = '161332d2-9fe2-11df-a531-12313900d531'
  inviteUrl = '/patient_management/invite?study_site_uuid=' + study_site_uuid + '&study_uuid=' + study_uuid
  email = 'jasmine@mdsol.com'
  initials = 'J.M.'
  inviteButtonEnabledDisabledSpy = undefined

  beforeEach ->
    loadFixtures 'patient_management/invite.html'
    inviteButtonEnabledDisabledSpy = spyOn(window, "inviteButtonEnabledDisabled")
    jasmine.Ajax.install()

  afterEach ->
    inviteButtonEnabledDisabledSpy.calls.reset()
    jasmine.Ajax.uninstall()

  describe 'clicking the invite button', ->
    refreshSubjectsSpy = undefined

    beforeEach ->
      refreshSubjectsSpy = spyOn(window, "refreshSubjects")
      $('#patient_enrollment_subject').val(subject).change()
      $('#patient_enrollment_country_language').val(countryLanguagePair).change()
      $('#patient_enrollment_email').val(email)
      $('#patient_enrollment_initials').val(initials)

    afterEach ->
      refreshSubjectsSpy.calls.reset()

    it 'makes a request to patient management invite', ->
      $('#invite-button').click()
      expect(jasmine.Ajax.requests.mostRecent().url).toBe inviteUrl

    describe 'errors', ->
      describe 'when there is no error', ->
        inviteResponse =           
            status: 201
            contentType: 'text/plain'
            responseText: ''

        beforeEach ->
          $('#invite-button').click()
          jasmine.Ajax.requests.mostRecent().response inviteResponse

        it 'has no error on the page', ->
          expect($('#invite-form-error')).toHaveClass('hidden')

        it 'refreshes the subject drop down', ->
          expect(refreshSubjectsSpy).toHaveBeenCalled()

        it 'clears the email and initial fields', ->
          expect($('#patient_enrollment_email').val()).toEqual('')
          expect($('#patient_enrollment_initials').val()).toEqual('')

        it 'enables or disables the invite button', ->
          expect(inviteButtonEnabledDisabledSpy).toHaveBeenCalled()

      describe 'when the call returns an error', ->
        inviteResponse =           
            status: 404
            contentType: 'application/json'
            responseText: 'Subject not available. Please try again later.'

        beforeEach ->
          $('#invite-button').click()
          jasmine.Ajax.requests.mostRecent().response inviteResponse

        it 'shows the error', ->
          expect($('#invite-form-error')).not.toHaveClass('hidden')
          expect($('#invite-form-error')).toHaveText(/Subject not available. Please try again later./)

        it 'refreshes the subject drop down', ->
          expect(refreshSubjectsSpy).toHaveBeenCalled()

        it 'does not clear the email and initial fields', ->
          expect($('#patient_enrollment_email').val()).toEqual(email)
          expect($('#patient_enrollment_initials').val()).toEqual(initials)

        it 'enables or disables the invite button', ->
          expect(inviteButtonEnabledDisabledSpy).toHaveBeenCalled()

        describe 'the x button', ->
          it 'hides the error', ->
            $('#error-x-button').click()
            expect($('#invite-form-error')).toHaveClass('hidden')

  describe 'refreshSubjects', ->
    availableSubjectsUrl = '/patient_management/available_subjects?study_uuid=' + study_uuid + '&study_site_uuid=' + study_site_uuid
    subjects = undefined
    availableSubjectsResponse = undefined

    beforeEach ->
      refreshSubjects()

    it 'requests new subjects', ->
      expect(jasmine.Ajax.requests.mostRecent().url).toBe availableSubjectsUrl

    describe 'when there are no more available subjects', ->
      beforeEach ->
        subjects = []
        availableSubjectsResponse =
          status: 200
          contentType: 'application/json'
          responseText: JSON.stringify(subjects)

      it 'populates the subjects dropdown with a "No subjects available message"', ->
        jasmine.Ajax.requests.mostRecent().response availableSubjectsResponse
        expect($('#patient_enrollment_subject option').length).toEqual(1)
        expect($('#patient_enrollment_subject option').first().text()).toEqual('No subjects available')

    describe 'when there are still available subjects', ->
      beforeEach ->
        subjects = [["Subject-001", "Subject-001"], ["Subject-002", "Subject-002"]]
        availableSubjectsResponse =
          status: 200
          contentType: 'application/json'
          responseText: JSON.stringify(subjects)

      it 'repopulates the subjects dropdown with the response', ->
        jasmine.Ajax.requests.mostRecent().response availableSubjectsResponse
        expect($('#patient_enrollment_subject option').length).toEqual(3)
        expect($('#patient_enrollment_subject option')[0].text).toEqual('Subject')
        expect($('#patient_enrollment_subject option')[1].text).toEqual(subjects[0][0])
        expect($('#patient_enrollment_subject option')[2].text).toEqual(subjects[1][1])

  describe 'inviteButtonEnabledDisabled', ->
    beforeEach ->
      # This is here on purpose, so we know the event handlers exist on $('#patient_enrollment_subject')
      #   and $('#patient_enrollment_country_language').
      inviteButtonEnabledDisabledSpy.and.callThrough()

    describe 'when a subject is selected', ->
      beforeEach ->
        $('#patient_enrollment_subject').val(subject).change()

      it 'is disabled', ->
        expect($('input#invite-button')).toHaveAttr('disabled', 'disabled')

    describe 'when a country / language pair is selected', ->
      beforeEach ->
        $('#patient_enrollment_country_language').val(countryLanguagePair).change()

      it 'is disabled', ->
        expect($('input#invite-button')).toHaveAttr('disabled', 'disabled')

    describe 'when both a subject and country / language pair are selected', ->
      beforeEach ->
        $('#patient_enrollment_subject').val(subject).change()
        $('#patient_enrollment_country_language').val(countryLanguagePair).change()

      it 'is enabled', ->
        expect($('input#invite-button')).not.toHaveAttr('disabled')

    describe 'when it is enabled and then a subject is deselected', ->
      beforeEach ->
        $('#patient_enrollment_subject').val(subject).change()
        $('#patient_enrollment_country_language').val(countryLanguagePair).change()
        $('#patient_enrollment_subject').val('').change()

      it 'is disabled', ->
        expect($('input#invite-button')).toHaveAttr('disabled', 'disabled')

  return
