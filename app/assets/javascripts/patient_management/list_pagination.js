$(function() {
  // Render page 1 with the default subset of records per page (25)
  renderEnrollments(1, 25);
  
  MUI.currentPage = 1;
  MUI.perPage = 25;
  MUI.recordCount = parseInt($('#total-count').html());
  MUI.totalPages = Math.ceil(MUI.recordCount/MUI.perPage);
  $('.total-pages').html(MUI.totalPages);
  
  $('a.next').on('click', nextPage)
  
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

var nextPage = function() {
 //TODO validate that we can go to another page?
  
  renderEnrollments(26, 50); 
}

var renderEnrollments = function(first, last) {
  var compiled = _.template('<tr class="patient_row"><td><%= created_at %></td><td><%= subject_identifier %></td><td><%= email %></td><td><%= initials %></td><td><%= activation_code %></td><td><%= state %></td></tr>');
  
  //remove the previous page of enrollments
  $('.patient_row').remove();
  
  //render the current page of enrollments
  for(el = (first - 1); el <= (last - 1); el++) {
    $('#patient-list tbody').append(compiled({
      created_at: MUI.patientEnrollments[el].created_at, 
      subject_identifier: MUI.patientEnrollments[el].subject_identifier,
      email: MUI.patientEnrollments[el].email,
      initials: MUI.patientEnrollments[el].initials,
      activation_code: MUI.patientEnrollments[el].activation_code,
      state: MUI.patientEnrollments[el].state
    }));
  }
}