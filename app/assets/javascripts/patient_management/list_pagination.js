$(function() {
  $("#current-page").data('validListPage', $("#current-page").val());
    $.validator.addMethod("validPageNumber",
      function(value, element) {
        var current_value = parseInt(value, 10),
          total_pages = parseInt($("#total-pages").text(), 10),
          logic = this.optional(element) || /^[1-9][0-9]*$/.test(value) && current_value <= total_pages;
        if (!logic) {
          $("#current-page").val($("#current-page").data('validListPage'));
        }
        return logic;
      },
      "Must be in range from 1 to the total number of pages"
    );

    $("#page-form").validate({
      onfocusout:function(element) {
        $(element).valid();
      },
      onkeyup:function(element) {
        $(element).valid();
      },
      errorPlacement:function() {}
    });
})