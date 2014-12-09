describe 'activation code page', ->
  describe 'getCodeString', ->
    describe 'when one character is entered', ->
      it 'determines the input string', ->
        setFixtures '<input class="code" id="code-1" maxlength="1" value="7" />'
        expect(getCodeString()).toEqual '7'
    
    describe 'when multiple characters are entered', -> 
      it 'determines the input string', ->
        loadFixtures 'activationCodeFixture.html'
        expect(getCodeString()).toEqual 'HEYMAN'
    
  describe 'on keyup event', ->
    describe 'for a character input', ->
      it 'calls getCodeString', ->
        loadFixtures 'activationCodeFixture.html'
        window.getCodeString = jasmine.createSpy('getCodeString spy').and.returnValue('H')
        $('.code').trigger 'keyup'
        expect(getCodeString).toHaveBeenCalled()
    
    describe 'for an empty input', ->  
      it 'calls getCodeString', ->
        loadFixtures 'activationCodeFixture.html'
        window.getCodeString = jasmine.createSpy('getCodeString spy').and.returnValue('')
        $('.code').trigger 'keyup'
        expect(getCodeString).toHaveBeenCalled()
        
    describe 'for a valid character', ->
      it "doesn't show a validation error", ->
        window.getCodeString = jasmine.createSpy('getCodeString spy').and.returnValue('ox9D0q')
        loadFixtures 'activationCodeFixture.html'
        $('.code').trigger 'keyup'
        expect($('.validation_error')).toHaveClass 'invisible'
      
    describe 'for an invalid character', ->
      it 'shows a validation error', ->
        loadFixtures 'activationCodeFixture.html'
        window.getCodeString = jasmine.createSpy('getCodeString spy').and.returnValue('NOOO0!')
        $('.code').trigger 'keyup'
        expect($('.validation_error')).not.toHaveClass 'invisible'
        
  describe 'when a field is selected', ->
    it 'highlights the existing character', ->
      loadFixtures 'activationCodeFixture.html'
      $('#code-3').trigger 'focus'
      expect(window.getSelection().toString()).toEqual('y')
  return
