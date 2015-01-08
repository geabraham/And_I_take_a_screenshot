$(function() {
  $('#code').focus();
  
  $('#code').on('keyup', handleInput);
  
  $('#activate-button').on('click', activate);
});

var activate = function() {
  $.get("/activation_codes/" + getCodeString() + "/activate");
}

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
        $(".validation_error").addClass('invisible');
        $(".activation-code").removeClass('has-error');
        $('#activate-button').removeAttr('disabled');
      } else {
        $(".validation_error").removeClass('invisible');
        $(".activation-code").addClass('has-error');
        $('#activate-button').attr('disabled', 'disabled');
      }
    } else {
      $('#activate-button').attr('disabled', 'disabled');
    }
  }
}
