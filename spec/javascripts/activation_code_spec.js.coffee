describe 'activation code page', ->
  it 'determines the input string when one character is entered', ->
    setFixtures '<input class="code" id="code-1" maxlength="1" value="7" />'
    expect(getInputString()).toEqual '7'
    return
    
  it 'determines the input string when multiple characters are entered', ->
    loadFixtures 'activationCodeFixture.html'
    expect(getInputString()).toEqual 'heyman'
    return
    
  it 'calls getInputString() on keyup event', ->
    loadFixtures 'activationCodeFixture.html'
    window.getInputString = jasmine.createSpy('getInputString spy').and.returnValue('H')
    $('.code').trigger 'keyup'
    expect(getInputString).toHaveBeenCalled()
    return
    
  it "doesn't show a validation error for a valid character", ->
    window.getInputString = jasmine.createSpy('getInputString spy').and.returnValue('ox9D0q')
    loadFixtures 'activationCodeFixture.html'
    expect($('.validation_error')).toHaveCss({display: "none"})
    return
    
  it 'shows a validation error for an invalid character', ->
    loadFixtures 'activationCodeFixture.html'
    window.getInputString = jasmine.createSpy('getInputString spy').and.returnValue('NOOO0!')
    $('.code').trigger 'keyup'
    expect($('.validation_error')).toHaveCss({display: "block"})
    return
    
  it 'handles an empty input', ->
    loadFixtures 'activationCodeFixture.html'
    window.getInputString = jasmine.createSpy('getInputString spy').and.returnValue('')
    $('.code').trigger 'keyup'
    expect(getInputString).toHaveBeenCalled()
    return
  return
