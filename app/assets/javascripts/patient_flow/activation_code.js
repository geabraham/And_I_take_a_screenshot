$(function() {
  if ($('#code').length > 0) {
    handleInput(); // fix for MCC-151106
  }
  
  $('#code').focus();
  
  $('#code').on('keyup', handleInput);
  
  $(document).keypress(function(e) {
      if (e.which == 13){
        debugger
        $('#activate-button').click();
      }
  });
});

var getCodeString = function() {
  return $.trim($('#code').val().toUpperCase());
}

var handleInput = function() {
  var str = getCodeString(),
            codeInput = $('#code');
            
            debugger
  
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
        $(".validation_error").addClass('invisible');
        $(".activation-code").removeClass('has-error');
        $('#activate-button').prop('href', '/activation_codes/' + str + '/validate')
        $('#activate-button').removeClass('disabled');
      } else {
        $(".validation_error").removeClass('invisible');
        $(".activation-code").addClass('has-error');
        $('#activate-button').prop('href', '')
        $('#activate-button').addClass('disabled');
      }
    } else {
      $('#activate-button').addClass('disabled');
    }
  }
}
