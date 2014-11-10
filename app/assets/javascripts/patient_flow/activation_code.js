$(".code").keyup(function(e) {
  var str = $.trim( $(".code#1").val() + $(".code#2").val() +$(".code#3").val() +
                    $(".code#4").val() + $(".code#5").val() +$(".code#6").val());
  if( str !== "" ) {
    var regx = /^[A-Za-z0-9]+$/;
    $(this).val($(this).val().toUpperCase());
    
    if(regx.test(str)) {
      $(".validation_error").hide();
      
      // submit if the full code has been filled in
      if(str.length === 6) {
        //TODO figure out what to stub out here for testing until the redirect
        //     to next screen is ready
        $.post( "/activate", { activation_code: str });
      }
    }
    else {
      $(".validation_error").show();
    }
  }
});
