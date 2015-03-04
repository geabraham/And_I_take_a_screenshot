describe 'activation code page', ->
  getSpy = undefined
  
  beforeEach ->
    loadFixtures 'activationCodeFixture.html'
    
  describe 'getCodeString', ->
    describe 'when one character is entered', ->
      it 'determines the input string', ->
        setFixtures '<input id="code" maxlength="1" value="7" />'
        expect(getCodeString()).toEqual '7'
    
    describe 'when multiple characters are entered', -> 
      it 'determines the input string', ->
        expect(getCodeString()).toEqual 'HEYMAN'
    
  describe 'on keyup event', ->
    describe 'for a character input', ->
      it 'calls getCodeString', ->
        window.getCodeString = jasmine.createSpy('getCodeString spy').and.returnValue('H')
        $('#code').trigger 'keyup'
        expect(getCodeString).toHaveBeenCalled()
    
    describe 'for an empty input', ->  
      it 'calls getCodeString', ->
        window.getCodeString = jasmine.createSpy('getCodeString spy').and.returnValue('')
        $('#code').trigger 'keyup'
        expect(getCodeString).toHaveBeenCalled()
      
    describe 'for an invalid character', ->
      beforeEach ->
        window.getCodeString = jasmine.createSpy('getCodeString spy').and.returnValue('NOOO0!')
        $('#code').trigger 'keyup'
        
      it 'shows a validation error', ->
        expect($('.validation_error')).not.toHaveClass 'invisible'
        expect($('.activation-code')).toHaveClass 'has-error'
        
  describe 'Activate button', ->      
    describe 'when less than six characters are entered', ->
      it 'is disabled', ->
        window.getCodeString = jasmine.createSpy('getCodeString spy').and.returnValue('N4')
        handleInput()
        expect($('#activate-button')).toHaveClass('disabled')
  
    describe 'when six characters are entered', ->
      describe 'with invalid characters present', ->
        it 'is disabled', ->
          window.getCodeString = jasmine.createSpy('getCodeString spy').and.returnValue('NOOO0!')
          handleInput()
          expect($('#activate-button')).toHaveClass('disabled')

        it 'has a blank href attribute', ->
          window.getCodeString = jasmine.createSpy('getCodeString spy').and.returnValue('NOOO0!')
          handleInput()
          expect($('#activate-button')).toHaveAttr('href', '')

      describe 'with no invalid characters present', ->
        it 'is enabled', ->
          window.getCodeString = jasmine.createSpy('getCodeString spy').and.returnValue('234567')
          handleInput()
          expect($('#activate-button')).not.toHaveClass('disabled')

        it 'has the right href attribute', ->
          window.getCodeString = jasmine.createSpy('getCodeString spy').and.returnValue('234567')
          handleInput()
          expect($('#activate-button')).toHaveAttr('href', '/activation_codes/234567/validate')

  return
