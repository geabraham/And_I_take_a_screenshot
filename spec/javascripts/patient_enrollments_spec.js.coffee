describe 'patient enrollments form', ->
  carouselSpy = undefined
  beforeEach ->
    loadFixtures 'patientEnrollmentFixture.html'
    carouselSpy = spyOn($.fn, 'carousel')
    
  afterEach ->
    carouselSpy.calls.reset()
    
  describe 'email page', ->
    beforeEach ->
      $('#email').addClass('active')
      # unlike on the actual page, set the fixture's active div manually since we're  
      # mocking the jQuery carousel call that would normally do so
      
    describe 'when back button is clicked', ->
      it 'stays on the current page', ->
        $('.back').trigger 'click'
        expect(carouselSpy.calls.any()).toEqual false # carousel should not change divs
        
    describe 'for a blank input', ->
      it 'shows a validation error', ->
        $('#reg-form').append('<input name="patient_enrollment[login]" value="" />')
        $('#next-button').trigger 'click'
        expect(carouselSpy.calls.any()).toEqual false
        expect($('.validation_error')).not.toHaveClass('invisible')
        expect($('.validation_error')).toHaveText('Enter a valid email.')
          
    describe 'next button click', ->
      describe 'for an invalid input', ->
        it 'shows a validation error', ->
          $('#reg-form').append('<input name="patient_enrollment[login]" value="not_an_email" />')
          $('#next-button').trigger 'click'
          expect(carouselSpy.calls.any()).toEqual false
          expect($('.validation_error')).not.toHaveClass('invisible')
          expect($('.validation_error')).toHaveText('Enter a valid email.')
          
      describe 'for a valid input', ->
        it 'advances to the password page', ->
          passwordRulesSpy = spyOn(window, 'addPasswordRules')
          validSpy= spyOn($.fn, 'valid').and.returnValue(true)
          $('#next-button').trigger 'click'
          expect(addPasswordRules).toHaveBeenCalled()
          expect(carouselSpy.calls.allArgs()).toEqual [['next']]
        
  describe 'password page', ->
    beforeEach ->
      $('#password').addClass('active')
      $('#password').append('<input id="patient_enrollment_password" class="registration-input" />')
      $('#password').append('<input id="patient_enrollment_password_confirmation" class="registration-input" />')
      addPasswordRules()
          
    describe 'next button click', ->
      describe 'for a blank input', ->
        it 'shows a validation error', ->
          $('#next-button').trigger 'click'
          expect(carouselSpy.calls.any()).toEqual false
          expect($('.validation_error')).not.toHaveClass('invisible')
          expect($('.validation_error')).toHaveText('Enter a valid password.')
          
      describe 'for an invalid input', ->
        it 'shows a validation error', ->
          $('#patient_enrollment_password').attr('value', 'Notagoodpassword')
          $('#patient_enrollment_password_confirmation').attr('value', 'Notagoodpassword')
          $('#next-button').trigger 'click'
          expect(carouselSpy.calls.any()).toEqual false
          expect($('.validation_error')).not.toHaveClass('invisible')
          expect($('.validation_error')).toHaveText('Enter a valid password.')
          
      describe 'for a valid input', ->
        it 'advances to the security question page', ->
          $('#patient_enrollment_password').attr('value', 'ASup3rG00dPassw0rd')
          $('#patient_enrollment_password_confirmation').attr('value', 'ASup3rG00dPassw0rd')
          $('#next-button').trigger 'click'
          expect(carouselSpy.calls.allArgs()).toEqual [['next']]
            
        it 'hides the "Next" button', ->
          validSpy= spyOn($.fn, 'valid').and.returnValue(true)
          $('#next-button').trigger 'click'
          expect(carouselSpy.calls.allArgs()).toEqual [['next']]
          expect($('#next-button')).toHaveClass('hidden')
          
        it 'displays the "Create account" button', ->
          validSpy= spyOn($.fn, 'valid').and.returnValue(true)
          $('#next-button').trigger 'click'
          expect(carouselSpy.calls.allArgs()).toEqual [['next']]
          expect($('#submit-button')).not.toHaveClass('hidden')
        
    describe 'back arrow click', ->
      describe 'for a blank input', ->
        it 'returns to the previous page', ->
          $('.back').trigger 'click'
          expect(carouselSpy.calls.allArgs()).toEqual [['prev']]
          
      describe 'for an invalid input', ->
        it 'stays on the current page', ->
          $('#patient_enrollment_password').attr('value', 'badpass')
          validSpy= spyOn($.fn, 'valid').and.returnValue(false)
          $('.back').trigger 'click'
          expect(carouselSpy.calls.any()).toEqual false # carousel should not change divs
          
      describe 'for a valid input', ->
        it 'returns to the previous page', ->
          validSpy= spyOn($.fn, 'valid').and.returnValue(true)
          $('.back').trigger 'click'
          expect(carouselSpy.calls.allArgs()).toEqual [['prev']]
      
  describe 'security question page', ->
    beforeEach ->
      $('#security-question').addClass('active')
      
    describe 'back arrow click', ->
      it 'returns to the previous page', ->
        $('.back').trigger 'click'
        expect(carouselSpy.calls.allArgs()).toEqual [['prev']]
        
      it 'displays the "Next" button', ->
        $('.back').trigger 'click'
        expect($('#next-button')).not.toHaveClass('hidden')
        
      it 'hides the "Create account" button', ->
        $('.back').trigger 'click'
        expect($('#create-account')).toHaveClass('hidden')
        
    describe 'create account button click', ->
      describe 'when security question is blank', ->
        it 'is disabled', ->
          $('#patient_enrollment_answer').val("the worst band is...")
          $('#patient_enrollment_security_question').trigger 'change'
          expect($('#create-account')).toHaveAttr('disabled', 'disabled')
          
      describe 'when security answer is blank', ->
        it 'is disabled', ->
          $('#patient_enrollment_security_question').val("What's the worst band in the world?")
          $('#patient_enrollment_security_question').trigger 'change'
          expect($('#create-account')).toHaveAttr('disabled', 'disabled')
          
      describe 'when both fields are filled', ->
        it 'is enabled', ->
          $('#patient_enrollment_security_question').val("What's the worst band in the world?")
          $('#patient_enrollment_answer').val("...")
          $('#patient_enrollment_security_question').trigger 'change'
          expect($('#create-account')).not.toHaveAttr('disabled', 'disabled')
  return
