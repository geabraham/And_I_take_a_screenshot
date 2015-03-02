describe 'patient management grid', ->  
  beforeEach ->
    loadFixtures 'patient_management/grid.html'
    
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
  return
