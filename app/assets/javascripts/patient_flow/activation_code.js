$(".code").keyup(function(e) {
  var str = $.trim( $(".code#1").val() + $(".code#2").val() +$(".code#3").val() +
                    $(".code#4").val() + $(".code#5").val() +$(".code#6").val());
  if( str != "" ) {
    var regx = /^[A-Za-z0-9]+$/;
    $(this).val($(this).val().toUpperCase());
    if (regx.test(str)) {
      $(".validation_error").hide();
    }
    else {
      $(".validation_error").show();
    }
  }
});