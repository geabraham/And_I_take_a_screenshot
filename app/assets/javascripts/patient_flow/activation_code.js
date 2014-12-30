$(function() {
  $('#code').focus();
  
  $("#code").on('keyup', handleInput);
});

var getCodeString = function() {
  var codeInput = $('#code'),
      str = $.trim(codeInput.val().toUpperCase());
  
  codeInput.val(str);
  
  return str;
}

var handleInput = function() {
  var str = getCodeString();
  
  if( str !== "" ) {
    var regx = /^[A-HJ-NP-Za-hj-np-z2-9]+$/;

    if(str.length === 6) {
      if(regx.test(str)) {
        $(".validation_error").addClass('invisible');
        $(".activation-code").removeClass('has-error');
        
        $.get("/activation_codes/" + str + "/activate");
      }
      else {
        $(".validation_error").removeClass('invisible');
        $(".activation-code").addClass('has-error');
      }
    }
  }
}
