describe 'patient management grid', ->
  # set up some sample patient enrollments to test pagination etc
  MUI = {}
  MUI.patientEnrollments = []
  x = 0
  while x < 106
    MUI.patientEnrollments.push
      activation_code: '24'
      created_at: '24-MAR-2015'
      email: '33*@gh**.com'
      initials: 'CMB'
      state: 'Invited'
      subject_id: 'MN008'
    x++
    
  
  
  describe 'records per page selector', ->
    describe '10 per page button', -> # can i make this into shared examples for all the other stuff
      it 'works', ->
        expect(2).toEqual(2)
        
  describe 'pagination controls', ->
    describe 'first button', ->
    describe 'previous button', ->
    describe 'next button', ->
    describe 'last button', ->
    describe 'page number input', ->
  return
