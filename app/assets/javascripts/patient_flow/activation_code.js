$(function() {
  $('#code-1').focus();
  
  $(".code").on('keyup', function(e) { 
    var keyPressed = e.which; 
    
    // for a tab (ascii 9), shift-tab, or backspace (ascii 9, 16, 8) in fields,
    // prevent handleInput() from deselecting the field and thus
    // requiring the user to backspace before fixing an inputted character
    if (keyPressed !== 8 && keyPressed !== 9 && keyPressed !== 16) { 
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
    
    $(this).val(input);
    codeString += input;
  });
  
  return codeString;
}

var handleInput = function() {
  var str = getCodeString(),
    currentInput = $('#' + document.activeElement.id);
  
  if( str !== "" ) {
    var regx = /^[A-HJ-NP-Za-hj-np-z2-9]+$/;

    if(regx.test(str)) {
      $(".validation_error").addClass('invisible');
  
      if(str.length === 6) {
        $.get("/activation_codes/" + str + "/activate");
      }
      else {
        currentInput.next().focus();
      }
    }
    else {
      $(".validation_error").removeClass('invisible');
    }
  }
}
