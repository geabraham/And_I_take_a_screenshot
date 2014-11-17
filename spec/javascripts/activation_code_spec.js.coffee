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
    expect(window.getInputString).toHaveBeenCalled()
    return
  return