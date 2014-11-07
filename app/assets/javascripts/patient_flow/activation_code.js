$(".code").keyup(function(e) {
  var str = $.trim( $(this).val() );
  if( str != "" ) {
      var regx = /^[A-Za-z0-9]+$/;
      if (!regx.test(str)) {
        $(".validation_error").show();
      }
      else {
        $(".validation_error").hide();
      }
    }
});

//TODO validate that ALL inputs are alphanumeric, not just one field