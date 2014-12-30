$(function() {
  $('#code').focus();
  
  $("#code").on('keyup', function(e) { 
      var keyPressed = e.which; 
    
      // for a backspace, left arrow, or right arrow (ascii 8, 37, or 39) in input,
      // prevent handleInput() from jumping cursor to the end of the field
      if (keyPressed !== 8 && keyPressed !== 37 && keyPressed !== 39) { 
        handleInput(); 
      }
    });
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
