$(function() {
  // set up global page state-related goodies
  MUI.currentPage = 1;
  MUI.perPage = 25;
  MUI.recordCount = parseInt($('#total-count').html());
  MUI.totalPages = Math.ceil(MUI.recordCount/MUI.perPage);
  $('.total-pages').html(MUI.totalPages);
  
  // Render page 1 with the default subset of records per page (25)
  renderEnrollments(1, 25);
  
  //TODO $('a.first').on('click', function() {});
  
  $('a.previous').on('click', function() {
    //TODO firstRecord = 1 + MUI.currentPage * MUI.perPage;
    if(MUI.currentPage == 2) {
      $(this).attr('disabled', true).addClass('disabled');
      $('a.first').attr('disabled', true).addClass('disabled');
      //TODO lastrecord
    }
    else if {MUI.currentPage > 2) {
      //TODO lastrecord
    }
    MUI.currentPage--;
    renderEnrollments(firstRecord, lastRecord);
  });
  
  $('a.next').on('click', function() {
    if(MUI.currentPage < MUI.totalPages) {
      firstRecord = 1 + MUI.currentPage * MUI.perPage;
      if (MUI.currentPage == 1) {
        $('a.first').removeAttr('disabled').removeClass('disabled');
        $('a.previous').removeAttr('disabled').removeClass('disabled');
      }
      if (MUI.currentPage < MUI.totalPages - 1) {
        lastRecord = (1 + MUI.currentPage) * MUI.perPage;
      }
      else if (MUI.currentPage == MUI.totalPages - 1) {
        lastRecord = MUI.recordCount;
        $(this).attr('disabled', true).addClass('disabled');
        $('a.last').attr('disabled', true).addClass('disabled');
      }
      MUI.currentPage++;
      renderEnrollments(firstRecord, lastRecord);
    }
  });
  
  $('a.last').on('click', function() {
    if (MUI.currentPage == 1) {
      $('a.first').removeAttr('disabled').removeClass('disabled');
      $('a.previous').removeAttr('disabled').removeClass('disabled');
    }
    firstRecord = (MUI.totalPages - 1) * MUI.perPage + 1;
    lastRecord = MUI.recordCount;
    MUI.currentPage = MUI.totalPages;
    $('a.next').attr('disabled', true).addClass('disabled');
    $(this).attr('disabled', true).addClass('disabled');
    renderEnrollments(firstRecord, lastRecord);
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
  
  // update the current page value in the control
  $('#current-page').val(MUI.currentPage);
}