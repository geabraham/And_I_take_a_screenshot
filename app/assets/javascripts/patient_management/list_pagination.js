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
    renderEnrollments(1, MUI.perPage);
  });
  
  $('a.previous').on('click', function() {
    MUI.currentPage--;
    
    firstRecord = (MUI.currentPage - 1) * MUI.perPage + 1;
    lastRecord = MUI.currentPage * MUI.perPage;
    
    renderEnrollments(firstRecord, lastRecord);
  });
  
  $('a.next').on('click', function() {
    if(MUI.currentPage < MUI.totalPages) {
      firstRecord = 1 + (MUI.currentPage * MUI.perPage);
      
      if (MUI.currentPage < MUI.totalPages - 1) {
        lastRecord = (1 + MUI.currentPage) * MUI.perPage;
      }
      else if (MUI.currentPage == MUI.totalPages - 1) {
        lastRecord = MUI.recordCount;
      }
      
      MUI.currentPage++;
      renderEnrollments(firstRecord, lastRecord);
    }
  });
  
  $('a.last').on('click', function() {
    firstRecord = (MUI.totalPages - 1) * MUI.perPage + 1;
    
    MUI.currentPage = MUI.totalPages;
    
    renderEnrollments(firstRecord, MUI.recordCount);
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

// render a page, or rather a range of instances of a template, corresponding to the specified first and last record
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
  
  // determine which of the arrow controls to enable
  // for first page
  if (MUI.currentPage == 1) {
    $('a.first, a.previous').attr('disabled', true).addClass('disabled');
    
    if (MUI.totalPages > 1) {
      $('a.next, a.last').removeAttr('disabled').removeClass('disabled');
    }
  }
  // for pages between the beginning and end
  else if (MUI.currentPage > 1 && MUI.currentPage < MUI.totalPages) {
    $('a.previous, a.first').removeAttr('disabled').removeClass('disabled');
    $('a.next, a.last').removeAttr('disabled').removeClass('disabled');
  }
  // for last page
  else if (MUI.currentPage == MUI.totalPages) {
    $('a.previous, a.first').removeAttr('disabled').removeClass('disabled');
    $('a.next, a.last').attr('disabled', true).addClass('disabled');
  }
  
  // update the current page value in the control
  $('#current-page').val(MUI.currentPage);
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
  
  //... and update globals
  MUI.patientEnrollments.unshift(newEnrollment);
  MUI.recordCount++;
  MUI.totalPages = Math.ceil(MUI.recordCount/MUI.perPage);
  $('.total-pages').html(MUI.totalPages);
  
  // TODO do this based on which page we're on
  renderEnrollments(1, MUI.perPage);
}