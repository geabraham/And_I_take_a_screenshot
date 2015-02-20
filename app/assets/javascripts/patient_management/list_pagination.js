$(function() {
  
  var compiled = _.template("<tr><td><%= created_at %></td><td><%= subject_identifier %></td><td><%= email %></td><td><%= initials %></td><td><%= activation_code %></td><td><%= state %></td></tr>");
  
  patientEnrollments = JSON.parse($('#enrollments').html());
  
  patientEnrollments.forEach(function(enrollment) {
    $('#patient-list tbody').append(compiled({
      created_at: enrollment.created_at, 
      subject_identifier: enrollment.subject_identifier,
      email: enrollment.email,
      initials: enrollment.initials,
      activation_code: enrollment.activation_code,
      state: enrollment.state
    }));
  });
  
  //TODO none of this works right now
  //$("#current-page").data('validListPage', $("#current-page").val());
  //  $.validator.addMethod("validPageNumber",
  //    function(value, element) {
  //      var current_value = parseInt(value, 10),
  //        total_pages = parseInt($("#total-pages").text(), 10),
  //        logic = this.optional(element) || /^[1-9][0-9]*$/.test(value) && current_value <= total_pages;
  //      if (!logic) {
  //        $("#current-page").val($("#current-page").data('validListPage'));
  //      }
  //      return logic;
  //    },
  //    "Must be in range from 1 to the total number of pages"
  //  );
  //
  //  $("#page-form").validate({
  //    onfocusout:function(element) {
  //      $(element).valid();
  //    },
  //    onkeyup:function(element) {
  //      $(element).valid();
  //    },
  //    errorPlacement:function() {}
  //  });
});

var renderEnrollments = function(first, last) {
  //TODO implement
}