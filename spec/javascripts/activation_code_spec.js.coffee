describe 'activation code page', ->
  describe 'getInputString', ->
    describe 'when one character is entered', ->
      it 'determines the input string', ->
        setFixtures '<input class="code" id="code-1" maxlength="1" value="7" />'
        expect(getInputString()).toEqual '7'
    
    describe 'when multiple characters are entered', -> 
      it 'determines the input string', ->
        loadFixtures 'activationCodeFixture.html'
        expect(getInputString()).toEqual 'heyman'
    
  describe 'on keyup event', ->
    describe 'for a character input', ->
      it 'calls getInputString', ->
        loadFixtures 'activationCodeFixture.html'
        window.getInputString = jasmine.createSpy('getInputString spy').and.returnValue('H')
        $('.code').trigger 'keyup'
        expect(getInputString).toHaveBeenCalled()
    
    describe 'for an empty input', ->  
      it 'calls getInputString', ->
        loadFixtures 'activationCodeFixture.html'
        window.getInputString = jasmine.createSpy('getInputString spy').and.returnValue('')
        $('.code').trigger 'keyup'
        expect(getInputString).toHaveBeenCalled()
        
    describe 'for a valid character', ->
      it "doesn't show a validation error", ->
        window.getInputString = jasmine.createSpy('getInputString spy').and.returnValue('ox9D0q')
        loadFixtures 'activationCodeFixture.html'
        $('.code').trigger 'keyup'
        expect($('.validation_error')).toHaveClass 'invisible'
      
    describe 'for an invalid character', ->
      it 'shows a validation error', ->
        loadFixtures 'activationCodeFixture.html'
        window.getInputString = jasmine.createSpy('getInputString spy').and.returnValue('NOOO0!')
        $('.code').trigger 'keyup'
        expect($('.validation_error')).not.toHaveClass 'invisible'
  return
