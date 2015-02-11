describe 'patient management invitation form', ->
  subject = 'Subject-000'
  countryLanguagePair = "{'language_code':'ara','country_code':'ISR'}"
  study_uuid = 'fda08b50-9fe1-11df-a531-12313900d531'
  study_site_uuid = '161332d2-9fe2-11df-a531-12313900d531'
  inviteUrl = '/patient_management/invite?study_site_uuid=' + study_site_uuid + '&study_uuid=' + study_uuid

  describe 'invite button', ->
    beforeEach ->
      loadFixtures 'patient_management/invite.html'
      jasmine.Ajax.install()

    afterEach ->
      jasmine.Ajax.uninstall()

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

    describe 'when clicked', ->
      beforeEach ->
        $('#patient_enrollment_subject').val(subject).change()
        $('#patient_enrollment_country_language').val(countryLanguagePair).change()

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

          it 'is hidden', ->
            expect($('#invite-form-error')).toHaveClass('hidden')

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

          describe 'the x button', ->
            it 'hides the error', ->
              $('#error-x-button').click()
              expect($('#invite-form-error')).toHaveClass('hidden')

  return
