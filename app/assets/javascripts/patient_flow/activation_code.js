$(function() {
  $(".code").on('keyup', function(e) { 
    var keyPressed = e.which; 
    
    // for a tab (ascii 9) or a shift-tab (ascii 9 & 16) between fields,
    // prevent handleInput() from deselecting the field and thus
    // requiring the user to backspace before fixing an inputted character
    if (keyPressed !== 9 && keyPressed !== 16) { 
      handleInput(); 
    }
  });
  
  $(".code").focus(function () {
    this.select();
  })
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
