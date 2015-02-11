// Add an on change handler to each dropdown item study and study site.
//
$(function() {
  var requiredFields = ['#patient_enrollment_subject', '#patient_enrollment_country_language']

  _.each(requiredFields, function(field) {
    $(field).on('change', function() { return inviteButtonEnabledDisabled(); })
  })

  $("#invite-form").on("ajax:success", function(e, data, status, xhr) {
    resetErrors()
  }).on("ajax:error", function(e, xhr, status, error) {
    resetErrors()
    $("#invite-form-error").removeClass('hidden')
    $("#invite-form-error span.message").append(xhr.responseText)
  });

  $('#error-x-button').on('click', function() {
    resetErrors()
  })
});

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
