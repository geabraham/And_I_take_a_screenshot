describe 'patient enrollments form', ->
  carouselSpy = undefined
  advanceProgressBarSpy = undefined
  reverseProgressBarSpy = undefined
  confirmTermsSpy = undefined
  confirmSpy = undefined
  redirectUserSpy = undefined
    
  beforeEach ->
    loadFixtures 'patientEnrollmentFixture.html'
    carouselSpy = spyOn($.fn, 'carousel')
    advanceProgressBarSpy = spyOn(window, 'advanceProgressBar')
    reverseProgressBarSpy = spyOn(window, 'reverseProgressBar')
    
  afterEach ->
    carouselSpy.calls.reset()
    advanceProgressBarSpy.calls.reset()
    reverseProgressBarSpy.calls.reset()
    
  describe 'landing_page', ->
    beforeEach ->
      # unlike on the actual page, set the fixture's active div manually since we're
      # mocking the jQuery carousel call that would normally do so
      $('#landing_page').addClass('active')
      
    sharedBehaviorForEvent = (event) ->
      describe event.name, ->
        it 'shows the Progress bar', ->
          $(event.selector).trigger event
          expect($('.progress')).not.toHaveClass('hidden')
        
        it 'hides the "Next" button', ->
          $(event.selector).trigger event
          expect($('#next-button')).toHaveClass('hidden')
        
        it 'shows the "I agree" button', ->
          $(event.selector).trigger event
          expect($('#agree-button')).not.toHaveClass('hidden')
          
    sharedBehaviorForEvent(jQuery.Event('click', name: 'next button click', selector: '#next-button'))
    sharedBehaviorForEvent(jQuery.Event('keypress', name: 'pressing the Enter key', selector: document, which: 13))

  describe 'tou_dpn_page', ->
    beforeEach ->
      $('#tou_dpn_agreement').addClass('active')

    describe 'when back button is clicked', ->
      it 'stays on the current page', ->
        $('.back_arrow').trigger 'click'
        expect(carouselSpy.calls.any()).toEqual false # carousel should not change divs
        expect(reverseProgressBarSpy.calls.any()).toEqual false
        
    sharedBehaviorForEvent = (event) ->
      describe event.name, ->
        beforeEach ->
          confirmTermsSpy = spyOn(window, 'confirmTerms')
          
        it 'calls confirmTerms()', ->
          $(event.selector).trigger event
          expect(confirmTermsSpy.calls.count()).toEqual 1
          
    sharedBehaviorForEvent(jQuery.Event('click', name: 'agree button click', selector: '#agree-button'))
    sharedBehaviorForEvent(jQuery.Event('keypress', name: 'pressing the Enter key', selector: document, which: 13))
    
    describe 'when user is asked to confirm agreement with TOU/DPN', ->
      describe 'when user clicks "OK"', ->
        beforeEach ->
          confirmSpy = spyOn(window, 'confirm').and.returnValue(true)
          
        it 'hides the agree button', ->
          confirmTerms()
          expect($('#agree-button')).toHaveClass('hidden')
      
        it 'shows the next button', ->
          confirmTerms()
          expect($('#next-button')).not.toHaveClass('hidden')
          
        it 'advances the progress bar', ->
          confirmTerms()
          expect(advanceProgressBarSpy.calls.count()).toEqual 1
          
      describe 'when user clicks "Cancel" but confirms on the subsequent dialog box', ->
        it 'redirects to the activation code page', ->
          confirmSpy = spyOn(window, 'confirm').and.returnValue(false)
          redirectUserSpy = spyOn(window, 'redirectUser')
          confirmTerms()
          expect(redirectUserSpy.calls.count()).toEqual 1

  describe 'email page', ->
    beforeEach ->
      $('#email').addClass('active')

    describe 'when back button is clicked', ->
      it 'does nothing', ->
        $('.back_arrow').trigger 'click'
        expect(carouselSpy.calls.any()).toEqual false
        expect(reverseProgressBarSpy.calls.any()).toEqual false
    
    sharedBehaviorForEvent = (event) ->      
      describe event.name, ->
        describe 'for a blank input', ->
          it 'shows a validation error', ->
            $('#reg-form').append('<input name="patient_enrollment[login]" value="" />')
            $(event.selector).trigger event
            expect(carouselSpy.calls.any()).toEqual false
            expect(advanceProgressBarSpy.calls.any()).toEqual false
            expect($('.validation_error')).not.toHaveClass('invisible')
            expect($('.validation_error')).toHaveText('Enter a valid email.')
            
        describe 'for an invalid input', ->
          it 'shows a validation error', ->
            $('#reg-form').append('<input name="patient_enrollment[login]" value="not_an_email" />')
            $(event.selector).trigger event
            expect(carouselSpy.calls.any()).toEqual false
            expect(advanceProgressBarSpy.calls.any()).toEqual false
            expect($('.validation_error')).not.toHaveClass('invisible')
            expect($('.validation_error')).toHaveText('Enter a valid email.')
            
        describe 'for a valid input', ->
          it 'advances to the password page', ->
            passwordRulesSpy = spyOn(window, 'addPasswordRules')
            validSpy= spyOn($.fn, 'valid').and.returnValue(true)
            $(event.selector).trigger event
            expect(addPasswordRules).toHaveBeenCalled()
            expect(carouselSpy.calls.allArgs()).toEqual [['next']]
            expect(advanceProgressBarSpy.calls.count()).toEqual 1
            
    sharedBehaviorForEvent(jQuery.Event('click', name: 'next button click', selector: '#next-button'))
    sharedBehaviorForEvent(jQuery.Event('keypress', name: 'pressing the Enter key', selector: document, which: 13))
          
  describe 'password page', ->
    beforeEach ->
      $('#password').addClass('active')
      $('#password').append('<input id="patient_enrollment_password" class="registration-input" />')
      $('#password').append('<input id="patient_enrollment_password_confirmation" class="registration-input" />')
      addPasswordRules()
    
    sharedBehaviorForEvent = (event) ->      
      describe event.name, ->
        describe 'for a blank input', ->
          it 'shows a validation error', ->
            $(event.selector).trigger event
            expect(carouselSpy.calls.any()).toEqual false
            expect(advanceProgressBarSpy.calls.any()).toEqual false
            expect($('.validation_error')).not.toHaveClass('invisible')
            expect($('.validation_error')).toHaveText('Enter a valid password.')
            
        describe 'for a weak password', ->
          it 'shows a validation error', ->
            $('#patient_enrollment_password').attr('value', 'Notagoodpassword')
            $('#patient_enrollment_password_confirmation').attr('value', 'Notagoodpassword')
            $(event.selector).trigger event
            expect(carouselSpy.calls.any()).toEqual false
            expect(advanceProgressBarSpy.calls.any()).toEqual false
            expect($('.validation_error')).not.toHaveClass('invisible')
            expect($('.validation_error')).toHaveText('Enter a valid password.')
            
        describe 'for a password with leading whitespace', ->
          it 'shows a validation error', ->
            $('#patient_enrollment_password').attr('value', ' AB4ddPasswrd')
            $('#patient_enrollment_password_confirmation').attr('value', ' AB4ddPasswrd')
            $(event.selector).trigger event
            expect(carouselSpy.calls.any()).toEqual false
            expect(advanceProgressBarSpy.calls.any()).toEqual false
            expect($('.validation_error')).not.toHaveClass('invisible')
            expect($('.validation_error')).toHaveText('Enter a valid password.')
            
        describe 'for a password with trailing whitespace', ->
          it 'shows a validation error', ->
            $('#patient_enrollment_password').attr('value', 'AB4ddPasswrd ')
            $('#patient_enrollment_password_confirmation').attr('value', 'AB4ddPasswrd ')
            $(event.selector).trigger event
            expect(carouselSpy.calls.any()).toEqual false
            expect(advanceProgressBarSpy.calls.any()).toEqual false
            expect($('.validation_error')).not.toHaveClass('invisible')
            expect($('.validation_error')).toHaveText('Enter a valid password.')
            
        describe 'for a password with multiple consecutive spaces', ->
          it 'shows a validation error', ->
            $('#patient_enrollment_password').attr('value', 'Notag  dpassw0rd')
            $('#patient_enrollment_password_confirmation').attr('value', 'Notag  dpassw0rd')
            $(event.selector).trigger event
            expect(carouselSpy.calls.any()).toEqual false
            expect(advanceProgressBarSpy.calls.any()).toEqual false
            expect($('.validation_error')).not.toHaveClass('invisible')
            expect($('.validation_error')).toHaveText('Enter a valid password.')
            
        describe 'for a password with one space not on either end', ->
          it 'advances to the security question page', ->
            $('#patient_enrollment_password').attr('value', 'ASup3rG00dPassw rd')
            $('#patient_enrollment_password_confirmation').attr('value', 'ASup3rG00dPassw rd')
            $(event.selector).trigger event
            expect(carouselSpy.calls.allArgs()).toEqual [['next']]
            expect(advanceProgressBarSpy.calls.count()).toEqual 1
            
        describe 'for a valid input', ->
          it 'advances to the security question page', ->
            $('#patient_enrollment_password').attr('value', 'ASup3rG00dPassw0rd')
            $('#patient_enrollment_password_confirmation').attr('value', 'ASup3rG00dPassw0rd')
            $(event.selector).trigger event
            expect(carouselSpy.calls.allArgs()).toEqual [['next']]
            expect(advanceProgressBarSpy.calls.count()).toEqual 1
              
          it 'hides the "Next" button', ->
            validSpy= spyOn($.fn, 'valid').and.returnValue(true)
            $(event.selector).trigger event
            expect(carouselSpy.calls.allArgs()).toEqual [['next']]
            expect($('#next-button')).toHaveClass('hidden')
            
          it 'displays the "Create account" button', ->
            validSpy= spyOn($.fn, 'valid').and.returnValue(true)
            $(event.selector).trigger event
            expect(carouselSpy.calls.allArgs()).toEqual [['next']]
            expect($('#submit-button')).not.toHaveClass('hidden')
            
    sharedBehaviorForEvent(jQuery.Event('click', name: 'next button click', selector: '#next-button'))
    sharedBehaviorForEvent(jQuery.Event('keypress', name: 'pressing the Enter key', selector: document, which: 13))
        
    describe 'back arrow click', ->
      describe 'for a blank input', ->
        it 'returns to the previous page', ->
          $('.back_arrow').trigger 'click'
          expect(carouselSpy.calls.allArgs()).toEqual [['prev']]
          expect(reverseProgressBarSpy.calls.count()).toEqual 1
          
      describe 'for an invalid input', ->
        it 'stays on the current page', ->
          $('#patient_enrollment_password').attr('value', 'badpass')
          validSpy= spyOn($.fn, 'valid').and.returnValue(false)
          $('.back_arrow').trigger 'click'
          expect(carouselSpy.calls.any()).toEqual false # carousel should not change divs
          expect(reverseProgressBarSpy.calls.any()).toEqual false
          
      describe 'for a valid input', ->
        it 'returns to the previous page', ->
          validSpy= spyOn($.fn, 'valid').and.returnValue(true)
          $('.back_arrow').trigger 'click'
          expect(carouselSpy.calls.allArgs()).toEqual [['prev']]
          expect(reverseProgressBarSpy.calls.count()).toEqual 1
      
  describe 'security question page', ->
    beforeEach ->
      $('#security-question').addClass('active')
      
    describe 'back arrow click', ->
      it 'returns to the previous page', ->
        $('.back_arrow').trigger 'click'
        expect(carouselSpy.calls.allArgs()).toEqual [['prev']]
        expect(reverseProgressBarSpy.calls.count()).toEqual 1
        
      it 'displays the "Next" button', ->
        $('.back_arrow').trigger 'click'
        expect($('#next-button')).not.toHaveClass('hidden')
        
      it 'hides the "Create account" button', ->
        $('.back_arrow').trigger 'click'
        expect($('#create-account')).toHaveClass('hidden')
        
    sharedBehaviorForEvent = (event) ->      
      describe event.name, ->
        describe 'when security question is blank', ->
          it 'is disabled', ->
            $('#patient_enrollment_answer').val("the worst band is...")
            $('#patient_enrollment_security_question').trigger 'change'
            expect($('#create-account')).toHaveAttr('disabled', 'disabled')
          
        describe 'when security answer is blank', ->
          it 'is disabled', ->
            $('#patient_enrollment_security_question').val("What's the worst band in the world?")
            $('#patient_enrollment_answer').val("   ")
            $('#patient_enrollment_security_question').trigger 'change'
            expect($('#create-account')).toHaveAttr('disabled', 'disabled')
          
        describe 'when security answer is whitespace', ->
          it 'is disabled', ->
          
        describe 'when both fields are filled', ->
          it 'is enabled', ->
            $('#patient_enrollment_security_question').val("What's the worst band in the world?")
            $('#patient_enrollment_answer').val("...")
            $('#patient_enrollment_security_question').trigger 'change'
            expect($('#create-account')).not.toHaveAttr('disabled', 'disabled')
            
    sharedBehaviorForEvent(jQuery.Event('click', name: 'create account button click', selector: '#create-account'))
    sharedBehaviorForEvent(jQuery.Event('keypress', name: 'pressing the Enter key', selector: document, which: 13))
          
  describe 'advanceProgressBar', ->
    it 'fills in the next segment of the bar', ->
      advanceProgressBarSpy.and.callThrough()
      expect($('.progress-bar-default').length).toEqual 1
      advanceProgressBar()
      expect($('.progress-bar-default').length).toEqual 2
      
  describe 'reverseProgressBar', ->
    it 'empties the last filled segment of the bar', ->
      reverseProgressBarSpy.and.callThrough()
      expect($('.progress-bar-default').length).toEqual 1
      do reverseProgressBar
      expect($('.progress-bar-default').length).toEqual 0
    
  return
