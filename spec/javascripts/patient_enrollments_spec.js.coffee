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
        return
        
    describe 'for a blank input', ->
      it 'shows a validation error', ->
        $('#reg-form').append('<input name="patient_enrollment[login]" value="" />')
        $('#next-button').trigger 'click'
        expect(carouselSpy.calls.any()).toEqual false
        expect($('.validation_error')).toHaveCss({display: 'block'})
        expect($('.validation_error')).toHaveText('Enter a valid email.')
        return
          
    describe 'next button', ->
      describe 'for an invalid input', ->
        it 'shows a validation error', ->
          $('#reg-form').append('<input name="patient_enrollment[login]" value="not_an_email" />')
          $('#next-button').trigger 'click'
          expect(carouselSpy.calls.any()).toEqual false
          expect($('.validation_error')).toHaveCss({display: 'block'})
          expect($('.validation_error')).toHaveText('Enter a valid email.')
          return
          
      describe 'for a valid input', ->
        it 'advances to the password page', ->
          passwordRulesSpy = spyOn(window, 'addPasswordRules')
          validSpy= spyOn($.fn, 'valid').and.returnValue(true)
          $('#next-button').trigger 'click'
          expect(addPasswordRules).toHaveBeenCalled()
          expect(carouselSpy.calls.allArgs()).toEqual [['next']]
          return
        
  describe 'password page', ->
    beforeEach ->
      $('#password').addClass('active')
      $('#reg-form').append('<input id="patient_enrollment_password" />')
      $('#reg-form').append('<input id="patient_enrollment_password_confirmation" />')
      addPasswordRules()
      
    describe 'when back button is clicked', ->
      it 'returns to the previous page', ->
        $('.back').trigger 'click'
        expect(carouselSpy.calls.allArgs()).toEqual [['prev']]
        return
          
    describe 'next button', ->
      describe 'for a blank input', ->
        it 'shows a validation error', ->
          $('#next-button').trigger 'click'
          expect(carouselSpy.calls.any()).toEqual false
          expect($('.validation_error')).toHaveCss({display: 'block'})
          expect($('.validation_error')).toHaveText('Enter a valid password.')
          return
          
      describe 'for an invalid input', ->
        it 'shows a validation error', ->
          $('#patient_enrollment_password').attr('value', 'Notagoodpassword')
          $('#patient_enrollment_password_confirmation').attr('value', 'Notagoodpassword')
          $('#next-button').trigger 'click'
          expect(carouselSpy.calls.any()).toEqual false
          expect($('.validation_error')).toHaveCss({display: 'block'})
          expect($('.validation_error')).toHaveText('Enter a valid password.')
          return
          
    describe 'for a valid input', ->
      it 'advances to the security question page', ->
        $('#patient_enrollment_password').attr('value', 'ASup3rG00dPassw0rd')
        $('#patient_enrollment_password_confirmation').attr('value', 'ASup3rG00dPassw0rd')
        $('#next-button').trigger 'click'
        expect(carouselSpy.calls.allArgs()).toEqual [['next']]
        return
          
      it 'hides the "Next" button', ->
        validSpy= spyOn($.fn, 'valid').and.returnValue(true)
        $('#next-button').trigger 'click'
        expect(carouselSpy.calls.allArgs()).toEqual [['next']]
        expect($('#next-button')).toHaveCss({display: 'none'})
        return
        
      it 'displays the "Create account" button', ->
        validSpy= spyOn($.fn, 'valid').and.returnValue(true)
        $('#next-button').trigger 'click'
        expect(carouselSpy.calls.allArgs()).toEqual [['next']]
        expect($('#submit-button')).toHaveCss({display: 'block'})
        return
      
  describe 'security question page', ->
    beforeEach ->
      $('#security-question').addClass('active')
      
    describe 'when back button is clicked', ->
      it 'returns to the previous page', ->
        $('.back').trigger 'click'
        expect(carouselSpy.calls.allArgs()).toEqual [['prev']]
        return
  #      
  #    it 'displays the "Next" button', ->
  #      pending
  #      return
  #      
  #    it 'hides the "Create account" button', ->
  #      pending
  #      return
  #      
  #    it 'returns to the password page', ->
  #      pending
  #      return
  #      
  #  describe 'create account button', ->
  #    describe 'when security question is blank', ->
  #      it 'is disabled', ->
  #        pending
  #        return
  #        
  #    describe 'when security answer is blank', ->
  #      it 'is disabled', ->
  #        pending
  #        return
  #        
  #    describe 'when both fields are filled', ->
  #      it 'is enabled', ->
  #        pending
  #        return
  #        
  #    describe 'when "Create account" button is clicked', ->
  #      it 'validates and submits the form', ->
  #        pending
  #        return
  return
