describe 'patient management grid', ->  
  beforeEach ->
    loadFixtures 'patient_management/grid.html'
    
  describe 'pagination controls', ->
    describe 'when disabled', -> #share examples here
      it 'stays on the current page', ->
        
    describe 'when enabled', ->
      it 'is disabled after click', -> #share examples here
      
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
              
      describe 'first button', ->
        it 'renders the first page', ->
          
      describe 'previous button', ->
        it 'renders the previous page', ->
          
      describe 'next button', ->
        it 'renders the next page', ->
          
      describe 'last button', ->
        it 'renders the last page', ->
          
      describe 'page number input', ->
  return
