$(function() {
  $(".code").on('keyup', handleInput);
});

var getInputString = function() {
  var inputString = "";
  $(".code").each(function() {
    inputString += $.trim($(this).val());
  });
  return inputString;
}

var handleInput = function() {
  $(this).val($(this).val().toUpperCase());
  str = getInputString();
  if( str !== "" ) {
    var regx = /^[A-Za-z0-9]+$/;

    if(regx.test(str)) {
      $(".validation_error").hide();
  
      if(str.length === 6) {
        $.post("/activation_codes/" + str + "/activate");
      }
    }
    else {
      $(".validation_error").show();
    }
  }
}