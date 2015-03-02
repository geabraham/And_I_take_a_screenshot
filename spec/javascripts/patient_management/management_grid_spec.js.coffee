describe 'patient management grid', ->  
  beforeEach ->
    loadFixtures 'patient_management/grid.html'
    
  describe 'pagination controls', ->
    describe 'when disabled', -> #share examples here
      it 'stays on the current page', ->
        
    describe 'when enabled', ->
      it 'is disabled after click', -> #share examples here
      
      describe 'records per page selector', ->
        describe 'clicking the 10 per page button', -> # can i make this into shared examples for all the other stuff
          describe 'when enabled', ->
            beforeEach ->
              $('#10-pp').click()
              
            it 'renders 10 records on the page', ->
              expect($('tr.patient_row').length).toEqual(10)
              
            it 'has the correct total number of pages', ->
              expect($('#total-pages').html()).toEqual('11')
              
            it 'renders the first page', ->
              expect($('#current-page').val()).toEqual('1')
              
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
