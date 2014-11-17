describe 'activation code page', ->
  it 'should pass', ->
    expect(1).toEqual 1
    return
    
  it "should have jasmine-jquery", ->
    loadFixtures "activationCodeFixture.html"
    expect($("#code_enter")).toHaveText "Please enter your activation code"
    return
    
  it 'determines the input string when one character is entered', ->
    setFixtures '<input class="code" id="code-1" maxlength="1" value="f" />'
    expect(getInputString()).toEqual 'f'
    return
  return