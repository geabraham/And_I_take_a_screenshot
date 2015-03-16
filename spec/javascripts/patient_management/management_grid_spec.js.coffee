describe 'patient management grid', ->  
  beforeEach ->
    loadFixtures 'patient_management/grid.html'

  describe 'new patient enrollment row', ->
    subjectData =
      created_at: new Date()
      subject_id: 'Subject-001'
      email: 'subject@gmail.com'
      initials: 'SB'
      activation_code: '93GX22'
      state: 'invited'

    beforeEach ->
      updateGrid(subjectData)

    it 'has created_at', ->
      expect($('tr.patient_row').first().children().eq(0).text()).toEqual(subjectData.created_at.toString())

    it 'has subject_id', ->
      expect($('tr.patient_row').first().children().eq(1).text()).toEqual(subjectData.subject_id)

    describe 'email', ->
      it 'has the email', ->
        expect($('tr.patient_row').first().children().eq(2).text()).toEqual(subjectData.email)

      it 'hides the email', ->
        expect($('tr.patient_row').first().children().eq(2)).toHaveClass('hidden')

    it 'has initials', ->
      expect($('tr.patient_row').first().children().eq(3).text()).toEqual(subjectData.initials)

    it 'has the activation_code', ->
      expect($('tr.patient_row').first().children().eq(4).text()).toEqual(subjectData.activation_code)

    it 'has the state', ->
      expect($('tr.patient_row').first().children().eq(5).text()).toEqual(subjectData.state)

  describe 'pagination controls', ->
    describe 'when disabled', -> #share examples here
      it 'stays on the current page', ->
        
    describe 'when enabled', ->
      beforeEach ->
        $('a.first,a.previous,a.next,a.last,#10-pp,#25-pp,#50-pp,#100-pp').removeClass('disabled')
        
      sharedBehaviorForEvent = (event) ->
        describe 'on click', ->
          beforeEach ->
            MUI.perPage = 11 # just a dummy value to set up the page as if we are coming from a different pagination setting
            $(event.selector).click()
            
          it 'is selected and disabled', ->
            expect($(event.selector)).toHaveClass('selected disabled')
          
      sharedBehaviorForEvent(jQuery.Event('click', name: '10 per page button click', selector: '#10-pp', rows: 10))
      sharedBehaviorForEvent(jQuery.Event('click', name: '25 per page button click', selector: '#25-pp', rows: 25))
      sharedBehaviorForEvent(jQuery.Event('click', name: '50 per page button click', selector: '#50-pp'))
      sharedBehaviorForEvent(jQuery.Event('click', name: '100 per page button click', selector: '#100-pp'))
      
      sharedBehaviorForEvent = (event) ->
        describe 'on click', ->
          beforeEach ->
            $(event.selector).click()
            
          it 'is disabled', ->
            expect($(event.selector)).toHaveClass('disabled')
      
      sharedBehaviorForEvent(jQuery.Event('click', name: 'first button click', selector: 'a.first'))
      sharedBehaviorForEvent(jQuery.Event('click', name: 'last button click', selector: 'a.last'))
      
      describe 'records per page selector', ->
        sharedBehaviorForEvent = (event) ->
          describe event.name, ->
            beforeEach ->
              $(event.selector).click()
              
            it 'renders the appropriate number of records on the page', ->
              expect($('tr.patient_row').length).toEqual(event.rows)
              
            it 'has the correct total number of pages', ->
              expect(parseInt($('#total-pages').html()), 10).toEqual(Math.ceil(105 / event.rows))
              
            it 'renders the first page', ->
              expect($('#current-page').val()).toEqual('1')
              
        sharedBehaviorForEvent(jQuery.Event('click', name: '10 per page button click', selector: '#10-pp', rows: 10))
        sharedBehaviorForEvent(jQuery.Event('click', name: '25 per page button click', selector: '#25-pp', rows: 25))
        sharedBehaviorForEvent(jQuery.Event('click', name: '50 per page button click', selector: '#50-pp', rows: 50))
        sharedBehaviorForEvent(jQuery.Event('click', name: '100 per page button click', selector: '#100-pp', rows: 100))
       
      describe 'pagination nav buttons', ->
        # uses default pagination of 25 per page with 105 dummy records, so 5 pages in total
        beforeEach -> #go to a page in the middle so all the buttons have somewhere to go
          MUI.currentPage = 3
          renderEnrollments(MUI.currentPage)
                  
        describe 'first button', ->
          it 'renders the first page', ->
            $('a.first').click()
            expect($('#current-page').val()).toEqual('1')
            
        describe 'previous button', ->
          it 'renders the previous page', ->
            $('a.previous').click()
            expect($('#current-page').val()).toEqual('2')
            
        describe 'next button', ->
          it 'renders the next page', ->
            $('a.next').click()
            expect($('#current-page').val()).toEqual('4')
            
        describe 'last button', ->
          it 'renders the last page', ->
            $('a.last').click()
            expect($('#current-page').val()).toEqual('5')
          
      describe 'page number input', ->
        sharedBehaviorForEvent = (event) ->
          describe event.name, -> 
            beforeEach ->
              $('#current-page').val(event.value).keyup()
              
            it 'shows a validation error', ->
              expect($('.validation_error')).not.toHaveClass('invisible')
              expect($('.validation_error')).toHaveText('Enter a valid page number.')
              
            it 'stays on the current page', ->
              expect(MUI.currentPage).toEqual(1)
              
        sharedBehaviorForEvent(new Object(name: 'for an invalid page number', value: '92'))
        sharedBehaviorForEvent(new Object(name: 'for a non-numeric input', value: 'jk'))
        
        describe 'for a valid input', ->
          beforeEach ->
            $('#current-page').val(3).trigger('keyup')
            
          it 'hides validation errors', ->
            expect($('.validation_error')).toHaveClass('invisible')
            
          it 'advances to the selected page', ->
            expect(MUI.currentPage).toEqual(3)
  return
