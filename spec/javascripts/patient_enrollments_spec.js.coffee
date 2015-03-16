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
        $('.back-arrow').trigger 'click'
        expect($('.back-arrow')).toHaveClass('hidden')

    sharedBehaviorForEvent = (event) ->
      describe event.name, ->
        it 'hides the landing page', ->
          $(event.selector).trigger event
          expect($('#landing_page')).not.toHaveClass('active')

        it 'shows the tou_dpn_agreement page', ->
          $(event.selector).trigger event
          expect($('#tou_dpn_agreement')).toHaveClass('active')

        it 'shows the Progress bar', ->
          $(event.selector).trigger event
          expect($('.progress')).not.toHaveClass('hidden')

    sharedBehaviorForEvent(jQuery.Event('click', name: 'next button click', selector: '#next-landing'))
    sharedBehaviorForEvent(jQuery.Event('keypress', name: 'pressing the Enter key', selector: document, which: 13))

  describe 'tou_dpn_page', ->
    beforeEach ->
      $('#tou_dpn_agreement').addClass('active')

    describe 'back arrow', ->
      # TODO fix wording and verify cases in MCC-151111
      # we may want to add/test a disabled class depending on implementation of the fix
      it 'is disabled', ->
        $('.back-arrow').trigger 'click'
        expect($('.back-arrow')).toHaveClass('hidden')

    describe 'agree button click', ->
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

    describe 'back arrow', ->
      it 'is disabled', ->
        $('.back-arrow').trigger 'click'
        expect($('.back-arrow')).toHaveClass('hidden')
        expect(progressBarSpy.calls.any()).toEqual false

    describe 'next button click', ->
      # new specs here!
      describe 'for missing confirmation email', ->
        beforeEach ->
          $('#patient_enrollment_login_confirmation').val("not_an_email")
          $('#patient_enrollment_login, #patient_enrollment_login_confirmation').trigger 'keyup'

        it 'remains on the email page', ->
          expect($('#email')).toHaveClass('active')
          expect($('#password')).not.toHaveClass('active')

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

  describe 'password page', ->
    beforeEach ->
      $('#email').addClass('active')
      $('#next-email').trigger 'click'
      addPasswordRules()

    describe 'next button click', ->
    #new specs here

      describe 'for a valid input', ->
        it 'advances to the security question page', ->
          spyAdvance = spyOn(progressBar, 'advance')
          $('#patient_enrollment_password').attr('value', 'ASup3rG00dPassw0rd')
          $('#patient_enrollment_password_confirmation').attr('value', 'ASup3rG00dPassw0rd')
          $('#patient_enrollment_password, #patient_enrollment_password_confirmation').trigger 'keyup'
          $('#next-password').trigger 'click'
          expect($('.progress-indicator').find('.incomplete').length).toEqual 2
          expect($('#security_question')).toHaveClass('active')
          expect(spyAdvance.calls.count()).toEqual 1

        it 'hides the password page', ->
          validSpy= spyOn($.fn, 'valid').and.returnValue(true)
          $('#next-password').trigger 'click'
          expect($('#password')).not.toHaveClass('active')

  #TODO BUG - MCC-151111
  #    describe 'back arrow', ->
  #      describe 'on click', ->
  #        describe 'for a blank input', ->
  #          it 'returns to the previous page', ->
  #            $('.back_arrow').trigger 'click'
  #            expect(carouselSpy.calls.allArgs()).toEqual [['prev']]
  #            expect(reverseProgressBarSpy.calls.count()).toEqual 1
  #
  #          it 'is hidden', ->
  #            $('.back_arrow').trigger 'click'
  #            expect($('.back_arrow')).toHaveClass 'hidden'
  #
  #        describe 'for an invalid input', ->
  #          it 'stays on the current page', ->
  #            $('#patient_enrollment_password').attr('value', 'badpass')
  #            validSpy= spyOn($.fn, 'valid').and.returnValue(false)
  #            $('.back_arrow').trigger 'click'
  #            expect(carouselSpy.calls.any()).toEqual false # carousel should not change divs
  #            expect(reverseProgressBarSpy.calls.any()).toEqual false
  #
  #        describe 'for a valid input', ->
  #          it 'returns to the previous page', ->
  #            validSpy= spyOn($.fn, 'valid').and.returnValue(true)
  #            $('.back_arrow').trigger 'click'
  #            expect(carouselSpy.calls.allArgs()).toEqual [['prev']]
  #            expect(reverseProgressBarSpy.calls.count()).toEqual 1
  #
  #          it 'is hidden', ->
  #            $('.back_arrow').trigger 'click'
  #            expect($('.back_arrow')).toHaveClass 'hidden'

  describe 'security question page', ->
    beforeEach ->
      $('#password').addClass('active')
      $('#next-password').trigger 'click'


    #describe 'back arrow', ->
    #  describe 'on click', ->
    #    it 'returns to the previous page', ->
    #      $('.back-arrow').trigger 'click'
    #          expect(carouselSpy.calls.allArgs()).toEqual [['prev']]
    #TODO Add progress bar test
    #          expect(reverseProgressBarSpy.calls.count()).toEqual 1
    #TODO BUG - MCC-151111
    #        it 'displays the "Next" button', ->
    #          debugger
    #          $('.back-arrow').trigger 'click'
    #          expect($('#password')).toHaveClass('active')

    #        it 'hides the "Create account" button', ->
    #          $('.back-arrow').trigger 'click'
    #          expect($('#security_question')).not.toHaveClass('active')
    describe 'submit button', ->
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

  return
