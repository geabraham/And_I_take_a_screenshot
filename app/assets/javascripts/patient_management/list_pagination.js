$(function() {
  // set up global pagination state variables
  MUI.currentPage = 1;
  MUI.perPage = 25;
  MUI.recordCount = parseInt($('#total-count').html());
  MUI.totalPages = Math.ceil(MUI.recordCount/MUI.perPage);
  $('.total-pages').html(MUI.totalPages);
  
  renderEnrollments(1, 25);
    
  $('a.first').on('click', function() {
    MUI.currentPage = 1;
    renderEnrollments(MUI.currentPage);
  });
  
  $('a.previous').on('click', function() {
    MUI.currentPage--;
    renderEnrollments(MUI.currentPage);
  });
  
  $('a.next').on('click', function() {
    MUI.currentPage++;
    renderEnrollments(MUI.currentPage);
  });
  
  $('a.last').on('click', function() {
    MUI.currentPage = MUI.totalPages;
    renderEnrollments(MUI.currentPage);
  });
  
  $('#10-pp, #25-pp, #50-pp, #100-pp').on('click', function() {
    var button = $(this), 
        oldButton = $('#' + MUI.perPage + '-pp')
        newVal = parseInt(button.html());
    
    if (newVal != MUI.perPage && !button.hasClass('disabled')) {
      oldButton.removeClass('selected disabled');
      button.addClass('selected disabled');
      
      //TODO DRY
      MUI.perPage = newVal;
      MUI.totalPages = Math.ceil(MUI.recordCount/MUI.perPage);
      $('.total-pages').html(MUI.totalPages);
      
      MUI.currentPage = 1;
      renderEnrollments(1, MUI.perPage);
    }
  })
  
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

// render a page of enrollments
var renderEnrollments = function(pageNumber) {
  var compiled = _.template('<tr class="patient_row"><td><%= created_at %></td><td><%= subject_identifier %></td><td><%= email %></td><td><%= initials %></td><td><%= activation_code %></td><td><%= state %></td></tr>'),
      first = 0,
      last = 0;
  
  //remove the previous page of enrollments
  $('.patient_row').remove();
  
  // determine the first and last records on the current page and enable/disable controls
  // for the first page
  if (MUI.currentPage == 1) {
    $('a.first, a.previous').attr('disabled', true).addClass('disabled');
    first = 1;
    last = MUI.perPage;
    
    // if first page is not the only page
    if (MUI.totalPages > 1) {
      $('a.next, a.last').removeAttr('disabled').removeClass('disabled');
    }
  }
  // for pages between the beginning and end
  else if (MUI.currentPage > 1 && MUI.currentPage < MUI.totalPages) {
    first = (MUI.currentPage - 1) * MUI.perPage + 1;
    last = MUI.currentPage * MUI.perPage;
    
    $('a.previous, a.first').removeAttr('disabled').removeClass('disabled');
    $('a.next, a.last').removeAttr('disabled').removeClass('disabled');
  }
  // for the last page
  else if (MUI.currentPage == MUI.totalPages) {
    first = (MUI.totalPages - 1) * MUI.perPage + 1;
    last = MUI.recordCount;
    
    $('a.previous, a.first').removeAttr('disabled').removeClass('disabled');
    $('a.next, a.last').attr('disabled', true).addClass('disabled');
  }
  
  // update the current page value in the control
  $('#current-page').val(MUI.currentPage);
  
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

var updateGrid = function(data) {
  // build new enrollment row...
  var newEnrollment = new Object();
  newEnrollment.created_at = data.created_at;
  newEnrollment.subject_identifier = data.subject_id;
  newEnrollment.email = data.email;
  newEnrollment.initials = data.initials;
  newEnrollment.activation_code = data.activation_code;
  newEnrollment.state = data.state;
  
  //... and update page state
  MUI.patientEnrollments.unshift(newEnrollment);
  $('#total-count').html(++MUI.recordCount)
  MUI.totalPages = Math.ceil(MUI.recordCount/MUI.perPage);
  $('.total-pages').html(MUI.totalPages);
  
  // TODO do this based on which page we're on
  renderEnrollments(MUI.currentPage);
}