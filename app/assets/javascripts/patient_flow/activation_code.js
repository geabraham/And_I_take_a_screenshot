$(function() {
  $(".code").on('keyup', handleInput);
});

var getCodeString = function() {
  var codeString = "";
  
  $(".code").each(function() {
    var input = $.trim($(this).val().toUpperCase());
    
    if (input.length > 0) {
      if (input === 'O') { input = '0'; }
      else if (input === 'I') { input = '1'; }
    }
    
    $(this).val(input);
    codeString += input;
  });
  
  return codeString;
}

var handleInput = function() {
  var str = getCodeString();
  
  if( str !== "" ) {
    var regx = /^[A-Za-z0-9]+$/; //TODO swap this

    if(regx.test(str)) {
      $(".validation_error").addClass('invisible');
  
      if(str.length === 6) {
        $.post("/activation_codes/" + str + "/activate");
      }
    }
    else {
      $(".validation_error").removeClass('invisible');
    }
  }
}
