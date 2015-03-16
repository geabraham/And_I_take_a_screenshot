$('.activation-code-content').ready(function() {
  if ($('#code').length > 0) {
    handleInput(); // fix for MCC-151106
  }
  
  $('#code').focus();
  
  $('#code').on('keyup', handleInput);
  
  $(document).on('keypress', function(e) {
      if (e.which == 13){
        $('#activate-button')[0].click();
      }
  });
});

var getCodeString = function() {
  return $.trim($('#code').val().toUpperCase());
}

var handleInput = function() {
  var str = getCodeString(),
            codeInput = $('#code');
  
  // update the string with upcased, trimmed value and prevent cursor from jumping to end
  selStart = codeInput.prop("selectionStart");
  selEnd = codeInput.prop("selectionEnd");
  codeInput.val(str);
  codeInput.prop("selectionStart",selStart);
  codeInput.prop("selectionEnd",selEnd);
  
  if( str !== "" ) {
    var regx = /^[A-HJ-NP-Za-hj-np-z2-9]+$/;

    if(str.length === 6) {
      if(regx.test(str)) {
        $(".validation_error").hide();
        $(".activation-code").removeClass('has-error');
        $('#activate-button').prop('href', '/activation_codes/' + str + '/validate')
        $('#activate-button').removeClass('disabled');
      } else {
        $(".validation_error").show();
        $(".activation-code").addClass('has-error');
        $('#activate-button').prop('href', '')
        $('#activate-button').addClass('disabled');
      }
    } else {
      $('#activate-button').addClass('disabled');
    }
  }
  else { // can occur if a user deletes all input at once
    $('#activate-button').prop('href', '')
    $('#activate-button').addClass('disabled');
  }
}
