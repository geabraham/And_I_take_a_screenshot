$(function() {
  $('.code').focus();
  
  $(".code").on('keyup', handleInput);
});

var getCodeString = function() {
  var codeString = "";
  
  $(".code").each(function() {
    var input = $.trim($(this).val().toUpperCase());
    
    $(this).val(input);
    codeString += input;
  });
  
  return codeString;
}

var handleInput = function() {
  var str = getCodeString();
  
  if( str !== "" ) {
    var regx = /^[A-HJ-NP-Za-hj-np-z2-9]+$/;

    if(regx.test(str)) {
      $(".validation_error").addClass('invisible');
      $(".activation-code").removeClass('has-error');
  
      if(str.length === 6) {
        $.get("/activation_codes/" + str + "/activate");
      }
    }
    else {
      $(".validation_error").removeClass('invisible');
      $(".activation-code").addClass('has-error');
    }
  }
}
