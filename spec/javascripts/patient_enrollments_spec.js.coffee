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
       #TODO localization for text not setup for tests
#       describe 'for a blank input', ->
#         it 'shows a validation error', ->
#           debugger
#           spyAdvance = spyOn(progressBar, 'advance')
#           $('#patient_enrollment_login').val(" ")
#           $('#patient_enrollment_login_confirmation').val(" ")
#           $('#patient_enrollment_login, #patient_enrollment_login_confirmation').trigger 'keyup'
#           $(event.selector).trigger event
#      #TODO This is because on the page if we do click from javascript for a disabled button it works.
#           # This could be because validation on click is removed RELATED TO BUG - MCC-151748
#           #            expect(spyAdvance.calls.count()).toEqual 0
#           #            expect(progressBarSpy.calls.any()).toEqual false
#           expect($('.validation_error')).not.toHaveClass('invisible')
#           expect($('.validation_error')).toHaveText('Enter a valid email.')
       #TODO - MCC-151926
       #        describe 'for an invalid input', ->
       #          it 'shows a validation error', ->
       #            $('#patient_enrollment_login').val("not_an_email")
       #            $('#patient_enrollment_login_confirmation').val("not_an_email")
       #            $('#patient_enrollment_login, #patient_enrollment_login_confirmation').trigger 'keyup'
       ##            $(event.selector).trigger event
       ##            expect(carouselSpy.calls.any()).toEqual false
       ##            expect(advanceProgressBarSpy.calls.any()).toEqual false
       #            expect($('.validation_error')).not.toHaveClass('invisible')
       #            expect($('.validation_error')).toHaveText('Enter a valid email.')
       #
       describe 'for missing confirmation email', ->
         it 'shows the next button is disabled', ->
           $('#patient_enrollment_login_confirmation').val("not_an_email")
           $('#patient_enrollment_login, #patient_enrollment_login_confirmation').trigger 'keyup'
           expect($('#next-email')).toHaveClass('disabled')
       describe 'for a valid input', ->
         it 'advances to the password page', ->
           passwordRulesSpy = spyOn(window, 'addPasswordRules')
           spyAdvance = spyOn(progressBar, 'advance')
           $('#patient_enrollment_login').val("gee@g.com")
           $('#patient_enrollment_login_confirmation').val("gee@g.com")
           $('#next-email').trigger 'click'
           expect(addPasswordRules).toHaveBeenCalled()
           expect($('#password')).toHaveClass('active')
           expect($('.progress-indicator').find('.incomplete').length).toEqual 2
           expect(spyAdvance.calls.count()).toEqual 1

  describe 'password page', ->
    beforeEach ->
      $('#email').addClass('active')
      $('#next-email').removeClass('disabled')
      $('#next-email').trigger 'click'
      addPasswordRules()

    describe 'next button click', ->
    #TODO BUG - Password has same value does not throw error
#        describe 'for a blank input', ->
#          it 'shows a validation error', ->
#            debugger
#            spyAdvance = spyOn(progressBar, 'advance')
#            $('#patient_enrollment_password').val("")
#            $('#patient_enrollment_password_confirmation').val("")
#            $('#patient_enrollment_password, #patient_enrollment_password_confirmation').trigger 'keyup'
#            $(event.selector).trigger event
#            expect($('.validation_error')).not.toHaveClass('invisible')
#            expect($('.validation_error')).toHaveText('Enter a valid password.')
    # TODO RELATED TO Validation on Next button(when we click disabled next it goes to next page)
        #            expect(spyAdvance.calls.count()).toEqual 0
#     TODO BUG  MCC-152706 - Password has same value does not throw error
#        describe 'for a weak password', ->
#          it 'shows a validation error', ->
#            debugger
#            $('#patient_enrollment_password').attr('value', 'Notagoodpassword')
#            $('#patient_enrollment_password_confirmation').attr('value', 'Notagoodpassword')
#            expect(progressBarSpy.calls.any()).toEqual false
#            $('#patient_enrollment_password, #patient_enrollment_password_confirmation').trigger 'keyup'
#            $(event.selector).trigger event
#            expect($('.validation_error')).not.toHaveClass('invisible')
#            expect($('.validation_error')).toHaveText('Enter a valid password.')

#        describe 'for a password with leading whitespace', ->
#          it 'shows a validation error', ->
#            $('#patient_enrollment_password').attr('value', ' AB4ddPasswrd')
#            $('#patient_enrollment_password_confirmation').attr('value', ' AB4ddPasswrd')
#            expect(progressBarSpy.calls.any()).toEqual false
#            $('#patient_enrollment_password, #patient_enrollment_password_confirmation').trigger 'keyup'
#            expect($('.validation_error')).not.toHaveClass('invisible')
#            expect($('.validation_error')).toHaveText('Enter a valid password.')
#
#        describe 'for a password with trailing whitespace', ->
#          it 'shows a validation error', ->
#            $('#patient_enrollment_password').attr('value', 'AB4ddPasswrd ')
#            $('#patient_enrollment_password_confirmation').attr('value', 'AB4ddPasswrd ')
#            expect(progressBarSpy.calls.any()).toEqual false
#            $('#patient_enrollment_password, #patient_enrollment_password_confirmation').trigger 'keyup'
#            expect($('.validation_error')).not.toHaveClass('invisible')
#            expect($('.validation_error')).toHaveText('Enter a valid password.')
#
#        describe 'for a password with multiple consecutive spaces', ->
#          it 'shows a validation error', ->
#            $('#patient_enrollment_password').attr('value', 'Notag  dpassw0rd')
#            $('#patient_enrollment_password_confirmation').attr('value', 'Notag  dpassw0rd')
#            expect(progressBarSpy.calls.any()).toEqual false
#            $('#patient_enrollment_password, #patient_enrollment_password_confirmation').trigger 'keyup'
#            expect($('.validation_error')).not.toHaveClass('invisible')
#            expect($('.validation_error')).toHaveText('Enter a valid password.')

      describe 'for a password with one space not on either end', ->
        it 'shows the next button is enabled', ->
          spyAdvance = spyOn(progressBar, 'advance')
          $('#patient_enrollment_password').attr('value', 'ASup3rG00dPassw rd')
          $('#patient_enrollment_password_confirmation').attr('value', 'ASup3rG00dPassw rd')
          $('#patient_enrollment_password, #patient_enrollment_password_confirmation').trigger 'keyup'
          expect($('#next-password')).not.toHaveClass('disabled')
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
        it 'shows the password page not as active', ->
          validSpy= spyOn($.fn, 'valid').and.returnValue(true)
          $('#next-password').trigger 'click'
          expect($('#password')).not.toHaveClass('active')
        it 'displays the "Create account" button disabled', ->
          validSpy= spyOn($.fn, 'valid').and.returnValue(true)
          $('#patient_enrollment_password, #patient_enrollment_password_confirmation').trigger 'keyup'
          $('#next-password').trigger 'click'
          expect($('#create-account')).toHaveClass('disabled')

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
      $('#next-password').removeClass('disabled')
      $('#next-password').trigger 'click'


    describe 'back arrow', ->
      describe 'on click', ->
        it 'returns to the previous page', ->
          $('.back-arrow').trigger 'click'
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
