$(function() {
  //validation rule for page number
  $.validator.addMethod("validPageNumber",
    function(value) {
      var current_value = parseInt(value, 10),
      total_pages = parseInt($("#total-pages").text(), 10),
      logic = /^[1-9][0-9]*$/.test(value) && current_value <= total_pages;
      return logic;
    });
    
    // initialize the page number input validator
    $('#page-form').validate({
      success: function() {
        $('.validation_error').addClass('invisible');
        // TODO refactor and cleanup
        //MUI.currentPage = parseint() from the form input
        //renderEnrollments(MUI.currentPage)
      },
      rules: {
        'current-page': {
          validPageNumber: true
        },
      },
      messages: {
        //TODO localize this string
        'current-page' : 'Enter a valid page number.'
      },
      errorPlacement: function(error, element) {
        $('.validation_error').html(error);
      },
    });
})