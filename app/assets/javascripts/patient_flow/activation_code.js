$(".code").keyup(function(e) {
  var str = "";
  $(".code").each(function() {
    str += $.trim($(this).val());
  });
  
  if( str !== "" ) {
    var regx = /^[A-Za-z0-9]+$/;
    $(this).val($(this).val().toUpperCase());
    
    if(regx.test(str)) {
      $(".validation_error").hide();
      
      // submit if the full code has been filled in
      if(str.length === 6) {
        //TODO figure out what to stub out here for testing until the redirect
        //     to next screen is ready
        var post_url = "/activation_codes/" + str + "/activate";
        $.post(post_url);
      }
    }
    else {
      $(".validation_error").show();
    }
  }
});
