// Add an on change handler to each dropdown item study and study site.
//
$(function() {
  $('#patient_enrollment_subject, #patient_enrollment_country_language').on('change', function() { return inviteButtonEnabledDisabled(); })

  $("#invite-form").on("ajax:success", function(e, data, status, xhr) {
    resetErrors();
    clearUserFields();
    refreshSubjects();
  }).on("ajax:error", function(e, xhr, status, error) {
    resetErrors();
    addError(xhr.responseText);
    refreshSubjects();
  });

  $('#error-x-button').on('click', function() {
    resetErrors();
  })
});

var clearUserFields = function() {
  $('#patient_enrollment_email').val('')
  $('#patient_enrollment_initials').val('')
}

var inviteButtonEnabledDisabled = function() {
  var subject = $('#patient_enrollment_subject option:selected')[0].value
  var languageCountryPair = $('#patient_enrollment_country_language option:selected')[0].value

  if(!$.isEmptyObject(subject) && !$.isEmptyObject(languageCountryPair)) {
    $('input#invite-button').prop('disabled', false)
  } else {
    $('input#invite-button').attr('disabled', 'disabled')
  }
}

var resetErrors = function() {
  $("#invite-form-error").addClass('hidden')
  $("#invite-form-error span.message").text('')
}

var addError = function(errorMessage) {
  $("#invite-form-error").removeClass('hidden')
  $("#invite-form-error span.message").append(errorMessage)
}

var refreshSubjects = function() {
  study_uuid = $('#invite-form').data().study_uuid
  study_site_uuid = $('#invite-form').data().study_site_uuid

  $.getJSON('/patient_management/available_subjects?study_uuid=' + study_uuid + '&study_site_uuid=' + study_site_uuid)
  .done(function(availableSubjects) {
    if (availableSubjects.length > 0) {
      $('#patient_enrollment_subject').empty().append('<option value>Subject</option>');
      var options = ''
      $.each(availableSubjects, function(index, value) {
        options += '<option value=' + value[1] + '>' + value[0] + '</option>'
      });
      $('#patient_enrollment_subject').append(options)
    } else {
      $('#patient_enrollment_subject').empty().append('<option value>No subjects available</option>');
    }
    // Wait until the subjects dropdown is re-populated to enable / disable (i.e. disable) the invite button.
    inviteButtonEnabledDisabled();
  });
}
