describe 'patient enrollments form', ->
  progressBarSpy = undefined
  confirmSpy = undefined
  validSpy = undefined
  spyAdvance = undefined

  beforeEach ->
    loadFixtures 'patientEnrollmentFixture.html'
    progressBarSpy = spyOn(window, 'progressBar')

  describe 'landing_page', ->
    beforeEach ->
      # set the fixture's active div ("screen") manually
      $('#landing_page').addClass('active')

    describe 'back arrow', ->
      it 'is disabled', ->
        expect($('.back-arrow')).toHaveClass('hidden')

    describe 'next button click', ->
      it 'hides the landing page', ->
        $('#next-landing').trigger 'click'
        expect($('#landing_page')).not.toHaveClass('active')

      it 'shows the tou_dpn_agreement page', ->
        $('#next-landing').trigger 'click'
        expect($('#tou_dpn_agreement')).toHaveClass('active')
        
      it 'shows the Progress bar', ->
        $('#next-landing').trigger 'click'
        expect($('.progress')).not.toHaveClass('hidden')

  describe 'tou_dpn_page', ->
    beforeEach ->
      $('#tou_dpn_agreement').addClass('active')

    describe 'clicking the agree button', ->
      it 'pops up a dialog confirming acceptance of the TOU/DPN', ->
        confirmSpy = spyOn(window, 'confirm').and.returnValue(false)
        $('#next-agree').trigger 'click'
        expect(confirmSpy.calls.count()).toEqual 1

    describe 'when user is asked to confirm agreement with TOU/DPN', ->
      describe 'when user clicks "OK"', ->
        beforeEach ->
          confirmSpy = spyOn(window, 'confirm').and.returnValue(true)
          $('#next-agree').trigger 'click'

        it 'hides the tou_dpn_agreement', ->
          expect($('#tou_dpn_agreement')).not.toHaveClass('active')

        it 'shows the email page', ->
          expect($('#email')).toHaveClass('active')

        it 'advances the progress bar', ->
          expect($('.progress-indicator').find('.incomplete').length).toEqual 2

        it 'focuses on the first email field', ->
          expect(document.activeElement).toEqual $('#patient_enrollment_login')[0]

      describe 'when user clicks "Cancel"', ->
        beforeEach ->
          confirmSpy = spyOn(window, 'confirm').and.returnValue(false)
          $('#next-agree').trigger 'click'

        it 'remains on the tou_dpn_agreement', ->
          expect($('#tou_dpn_agreement')).toHaveClass('active')
          expect($('#email')).not.toHaveClass('active')

        it 'does not advance the progress bar', ->
          expect($('.progress-indicator .incomplete').length).toEqual 3

  describe 'email page', ->
    beforeEach ->
      $('#email').addClass('active')
      progressBar.advance(1)

    describe 'clicking the next button', ->
      # it wasn't immediately clear how to hook up i18n with Jasmine,
      # so for now these specs verify that the correct unlocalized strings appear
      describe 'for a blank input', ->
        it 'shows a validation error', ->
          $('#next-email').trigger 'click'
          expect($('.validation_error')).toHaveText('[registration.email_form.validation_error]')

      describe 'for missing confirmation email', ->
        it 'shows a validation error', ->
          $('#patient_enrollment_login').val("gee@g.com")
          $('#next-email').trigger 'click'
          expect($('.validation_error')).toHaveText('[registration.email_form.validation_error]')

      describe 'for an invalid input', ->
        it 'shows a validation error', ->
          $('#patient_enrollment_login').val("not_an_email")
          $('#patient_enrollment_login_confirmation').val("not_an_email")
          $('#next-email').trigger 'click'
          expect($('.validation_error')).toHaveText('[registration.email_form.validation_error]')

      describe 'for a mismatching input', ->
        it 'shows a mismatch error', ->
          $('#patient_enrollment_login').val("gee@g.com")
          $('#patient_enrollment_login_confirmation').val("gee@g2.com")
          $('#next-email').trigger 'click'
          expect($('.validation_error')).toHaveText('[registration.email_form.mismatch_error]')

      describe 'for a valid input', ->
        beforeEach ->
          passwordRulesSpy = spyOn(window, 'addPasswordRules')
          spyAdvance = spyOn(progressBar, 'advance')
          $('#patient_enrollment_login').val("gee@g.com")
          $('#patient_enrollment_login_confirmation').val("gee@g.com")
          $('#next-email').trigger 'click'

        it 'advances to the password page', ->
          expect($('#password')).toHaveClass('active')

        it 'advances the progress bar', ->
          expect($('.progress-indicator').find('.incomplete').length).toEqual 2
          expect(spyAdvance.calls.count()).toEqual 1

        it 'adds validation rules for the password page', ->
          expect(addPasswordRules).toHaveBeenCalled()

        it 'focuses on the first password field', ->
          expect(document.activeElement).toEqual $('#patient_enrollment_password')[0]

        it 'displays the back arrow', ->
          expect($('.back-arrow')).not.toHaveClass('hidden')

  describe 'password page', ->
    describe 'clicking the next button', ->
      beforeEach ->
        $('#password').addClass('active')
        addPasswordRules()

      describe 'for a blank input', ->
        # it wasn't immediately clear how to hook up i18n with Jasmine,
        # so for now these specs verify that the correct non-localized strings appear
        it 'shows a validation error', ->
          $('#next-password').trigger 'click'
          expect($('.validation_error')).toHaveText('[registration.password_form.validation_error]')

      describe 'for a blank confirmation input', ->
        it 'shows a validation error', ->
          $('#patient_enrollment_password').attr('value', 'ASup3rG00dPassw0rd')
          $('#next-password').trigger 'click'
          expect($('.validation_error')).toHaveText('[registration.password_form.validation_error]')

      describe 'for an invalid input', ->
        it 'shows a validation error', ->
          $('#patient_enrollment_password').attr('value', 'weakpass')
          $('#patient_enrollment_password_confirmation').attr('value', 'weakpass')
          $('#next-password').trigger 'click'
          expect($('.validation_error')).toHaveText('[registration.password_form.validation_error]')

      describe 'for mismatching passwords', ->
        it 'shows a mismatch error', ->
          $('#patient_enrollment_password').attr('value', 'Password1')
          $('#patient_enrollment_password_confirmation').attr('value', 'Password2')
          $('#next-password').trigger 'click'
          expect($('.validation_error')).toHaveText('[registration.password_form.mismatch_error]')

      describe 'for a valid input', ->
        beforeEach ->
          $('#patient_enrollment_password').attr('value', 'ASup3rG00dPassw0rd')
          $('#patient_enrollment_password_confirmation').attr('value', 'ASup3rG00dPassw0rd')
          $('#next-password').trigger 'click'

        it 'advances to the security question page', ->
          expect($('.progress-indicator').find('.incomplete').length).toEqual 2
          expect($('#security_question')).toHaveClass('active')

        it 'hides the password page', ->
          expect($('#password')).not.toHaveClass('active')

    describe 'when the back arrow is clicked', ->
      beforeEach ->
        # NOTE: In order to use the Back button properly, the JavaScript maintains internal state of what page the user
        # is on. This can't be easily changed from the outside, so this drives the forms forward to test the button

        # All forms are assumed to be valid for this test
        spyOn($.fn, 'valid').and.returnValue(true)
        $('#next-landing').trigger 'click'

        # Accept the TOU/DPN
        confirmSpy = spyOn(window, 'confirm').and.returnValue(true)
        $('#next-agree').trigger 'click'

        $('#next-email').trigger 'click'
        $('.back-arrow').trigger 'click'

      it 'hides the back arrow', ->
        expect($('.back-arrow')).toHaveClass('hidden')

      it 'hides the password page', ->
        expect($('#password')).not.toHaveClass('active')

      it 'displays the email page', ->
        expect($('#email')).toHaveClass('active')

      it 'moves the progress bar back by 1', ->
        expect($('.progress-indicator .incomplete').length).toEqual 2


  describe 'security question page', ->
    describe 'submit button', ->
      beforeEach ->
        $('#password').addClass('active')
        $('#next-password').trigger 'click'

      describe 'on click', ->
        beforeEach ->
          $('#patient_enrollment_security_question').val('1')
          $('#patient_enrollment_answer').val('1234')
          $('#patient_enrollment_answer').trigger 'keyup'
          submitCallback = jasmine.createSpy('spy').and.returnValue(false)
          $('#reg-form').submit(submitCallback)
          $('#create-account').click()

        it 'is disabled', ->
          expect($('#create-account')).toHaveClass('disabled')

        it 'disables the security question dropdown', ->
          expect($('#patient_enrollment_security_question')).toHaveClass('disabled')

        it 'disables the security question answer box', ->
          expect($('#patient_enrollment_answer')).toHaveClass('disabled')

      describe 'create account button', ->
        describe 'when security question is blank', ->
          it 'is disabled', ->
            $('#patient_enrollment_answer').val("the worst band is...")
            $('#patient_enrollment_answer').trigger 'keyup'
            expect($('#create-account')).toHaveClass('disabled')
  
        describe 'when security answer is whitespace', ->
          it 'is disabled', ->
            $('#patient_enrollment_security_question').val("What's the worst band in the world?")
            $('#patient_enrollment_answer').val("   ")
            $('#patient_enrollment_answer').trigger 'keyup'
            expect($('#create-account')).toHaveClass('disabled')
  
        describe 'when both fields are filled', ->
          it 'is enabled', ->
            $('#patient_enrollment_security_question').val(1)
            $('#patient_enrollment_answer').val("....")
            $('#patient_enrollment_answer').trigger 'keyup'
            expect($('#create-account')).not.toHaveClass('disabled')

    describe 'when the back arrow is clicked', ->
      beforeEach ->
        # NOTE: In order to use the Back button properly, the JavaScript maintains internal state of what page the user
        # is on. This can't be easily changed from the outside, so this drives the forms forward to test the button
        
        # All forms are assumed to be valid for this test
        spyOn($.fn, 'valid').and.returnValue(true)
        $('#next-landing').trigger 'click'

        # Accept the TOU/DPN
        confirmSpy = spyOn(window, 'confirm').and.returnValue(true)
        $('#next-agree').trigger 'click'

        $('#next-email').trigger 'click'
        $('#next-password').trigger 'click'
        $('.back-arrow').trigger 'click'

      it 'hides the security question page', ->
        expect($('#security_question')).not.toHaveClass('active')

      it 'displays the password page', ->
        expect($('#password')).toHaveClass('active')

      it 'moves the progress bar back by 1', ->
        expect($('.progress-indicator .incomplete').length).toEqual 1

  describe 'using ajax for form submission', ->
    windowLocationSpy = undefined
    htmlSpy = undefined
    registrationResponse =
        status: 201
        contentType: 'text/plain'
        responseText: ''

    beforeEach ->
      jasmine.Ajax.install()
      windowLocationSpy = spyOn(window.location, 'assign')
      htmlSpy = spyOn($.fn, 'html')
      $('#reg-form').submit()

    afterEach ->
      windowLocationSpy.calls.reset()
      jasmine.Ajax.uninstall()

    it 'calls the registration route', ->
      expect(jasmine.Ajax.requests.mostRecent().url).toBe('/patient_enrollments/0c948408-43e9-428f-8f07-d1fca081e751/register')

    describe 'success', ->
      it 'triggers patient-cloud:registration-complete', ->
        jasmine.Ajax.requests.mostRecent().response registrationResponse
        expect(windowLocationSpy).toHaveBeenCalledWith("patient-cloud:registration-complete")

    # Show plain text error on failure.
    describe 'error', ->
      serviceUnavailable = 'Service Unavailable'
      registrationErrorResponse =
          status: 503
          contentType: 'text/plain'
          statusText: serviceUnavailable
      
      # Use a spy becausing testing the actual html prevents the jasmine process from exiting at the end of the test suite.
      it 'renders the error in the body of the document', ->
        jasmine.Ajax.requests.mostRecent().response registrationErrorResponse
        expect(htmlSpy).toHaveBeenCalledWith(serviceUnavailable)
  return
