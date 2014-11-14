var str = ""

$(".code").keyup(function(e) {
  $(this).val($(this).val().toUpperCase());
  
  str = getInputString();
  
  if( str !== "" ) {
    var regx = /^[A-Za-z0-9]+$/;
    
    if(regx.test(str)) {
      $(".validation_error").hide();
      
      // submit if the full code has been filled in
      if(str.length === 6) {
        //TODO figure out what to stub out here for testing until the redirect
        //     to next screen is ready
        $.post("/activation_codes/" + str + "/activate");
      }
    }
    else {
      $(".validation_error").show();
    }
  }
});

function getInputString() {
  var inputString = "";
  $(".code").each(function() {
    inputString += $.trim($(this).val());
  });
  return inputString;
}