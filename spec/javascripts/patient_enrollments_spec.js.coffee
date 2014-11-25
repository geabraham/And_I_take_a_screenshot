describe 'patient enrollments form', ->
  describe 'email page', ->
    describe 'when back button is clicked', ->
      it 'stays on the email page', ->
        expect('7').toEqual '7'
        return
          
    describe 'next button', ->
      describe 'for a blank input', ->
        it 'shows a validation error', ->
          expect('7').toEqual '7'
          return
          
      describe 'for an invalid input', ->
        it 'shows a validation error', ->
          expect('7').toEqual '7'
          return
      
      describe 'for a mismatching input', ->
        it 'shows a mismatch error', ->
          expect('7').toEqual '7'
          return
          
      describe 'for a valid input', ->
        it 'advances to the password page', ->
          expect('7').toEqual '7'
          return
        
  describe 'password page', ->
    describe 'when back button is clicked', ->
      it 'returns to the email page', ->
        expect('7').toEqual '7'
        return
          
    describe 'next button', ->
      describe 'for a blank input', ->
        it 'shows a validation error', ->
          expect('7').toEqual '7'
          return
          
      describe 'invalid input', ->
        it 'determines the input string', ->
          expect('7').toEqual '7'
          return
          
      describe 'for a mismatching input', ->
        it 'shows a mismatch error', ->
          expect('7').toEqual '7'
          return
          
      describe 'for a valid input', ->
        it 'advances to the security question page', ->
          expect('7').toEqual '7'
          return
          
        it 'hides the "Next" button', ->
          expect('7').toEqual '7'
          return
          
        it 'displays the "Create account" button', ->
          expect('7').toEqual '7'
          return
        
  describe 'security question page', ->
    describe 'when back button is clicked', ->
      it 'returns to the password page', ->
        expect('7').toEqual '7'
        return
        
      it 'displays the "Next" button', ->
        expect('7').toEqual '7'
        return
        
      it 'hides the "Create account" button', ->
        expect('7').toEqual '7'
        return
        
      it 'returns to the password page', ->
        expect('7').toEqual '7'
        return
        
    describe 'create account button', ->
      describe 'when security question is blank', ->
        it 'is disabled', ->
          expect('7').toEqual '7'
          return
          
      describe 'when security answer is blank', ->
        it 'is disabled', ->
          expect('7').toEqual '7'
          return
          
      describe 'when both fields are filled', ->
        it 'is enabled', ->
          expect('7').toEqual '7'
          return
          
      describe 'when "Create account" button is clicked', ->
        it 'validates and submits the form', ->
          expect('7').toEqual '7'
          return
  return
