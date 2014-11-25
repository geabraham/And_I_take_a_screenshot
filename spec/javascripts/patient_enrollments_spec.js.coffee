describe 'patient enrollments form', ->
  describe 'email page', ->
    describe 'when back button is clicked', ->
#      it 'stays on the email page', ->
#        loadFixtures 'patientEnrollmentFixture.html'
#        $('.back').trigger 'click'
#        pending #this could have all sorts of odd dependencies on carousel being loaded by jasmine
#        return
          
#    describe 'next button', ->
#      describe 'for a blank input', ->
#        it 'shows a validation error', ->
#          pending
#          return
#          
      describe 'for an invalid input', ->
        it 'shows a validation error', ->
          loadFixtures 'patientEnrollmentFixture.html'
          # this html sets up a blank input which should set off the validator
          $('#reg-form').append('<input name="patient_enrollment[login]" value="" />')
          window.addPasswordRules = jasmine.createSpy('addPasswordRules spy')
          carouselSpy = spyOn(jQuery.fn, 'carousel')
          $('#next-button').trigger 'click'
          expect(carouselSpy.calls.any()).toEqual false # page should not advance
          expect($('.validation_error')).toHaveCss({display: 'block'})
          return
#      
#      describe 'for a mismatching input', ->
#        it 'shows a mismatch error', ->
#          pending
#          return
          
      describe 'for a valid input', ->
        it 'advances to the password page', ->
          loadFixtures 'patientEnrollmentFixture.html'
          window.addPasswordRules = jasmine.createSpy('addPasswordRules spy')
          validSpy= spyOn(jQuery.fn, 'valid').and.returnValue(true)
          carouselSpy = spyOn(jQuery.fn, 'carousel')
          $('#next-button').trigger 'click'
          expect(addPasswordRules).toHaveBeenCalled()
          expect(carouselSpy.calls.allArgs()).toEqual [['next']]
          return
        
  #describe 'password page', ->
  #  describe 'when back button is clicked', ->
  #    it 'returns to the email page', ->
  #      pending
  #      return
  #        
  #  describe 'next button', ->
  #    describe 'for a blank input', ->
  #      it 'shows a validation error', ->
  #        pending
  #        return
  #        
  #    describe 'invalid input', ->
  #      it 'determines the input string', ->
  #        pending
  #        return
  #        
  #    describe 'for a mismatching input', ->
  #      it 'shows a mismatch error', ->
  #        pending
  #        return
  #        
  #    describe 'for a valid input', ->
  #      it 'advances to the security question page', ->
  #        pending
  #        return
  #        
  #      it 'hides the "Next" button', ->
  #        pending
  #        return
  #        
  #      it 'displays the "Create account" button', ->
  #        pending
  #        return
  #      
  #describe 'security question page', ->
  #  describe 'when back button is clicked', ->
  #    it 'returns to the password page', ->
  #      pending
  #      return
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
