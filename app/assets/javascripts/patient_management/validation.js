$(function() {
  //validation rule for page number
  $.validator.addMethod("validPageNumber",
    function(value, element) {
      var current_value = parseInt(value, 10),
      total_pages = parseInt($("#total-pages").text(), 10),
      logic = this.optional(element) || /^[1-9][0-9]*$/.test(value) && current_value <= total_pages;
      return logic;
    });
    
    // initialize the page number input validator
    $('#page-form').validate({
      onfocusout: function(element) {
        $(element).valid();
      },
      onkeyup: function(element) {
        $(element).valid();
      },
      success: function() {
        $('.validation_error').addClass('invisible');
        pageInput = parseInt($('#current-page').val(), 10);
        
        if (!isNaN(pageInput)) {
          MUI.currentPage = parseInt($('#current-page').val(), 10);
          renderEnrollments(MUI.currentPage)
        }
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
        $('.validation_error').removeClass('invisible');
        $('.validation_error').html(error);
      },
    });
})
