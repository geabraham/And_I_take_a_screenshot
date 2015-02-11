// Add an on change handler to each dropdown item study and study site.
//
$(function() {
  var requiredFields = ['#patient_enrollment_subject', '#patient_enrollment_country_language']

  _.each(requiredFields, function(field) {
    $(field).on('change', function() { return inviteButtonEnabledDisabled(); })
  })

  $("#invite-form").on("ajax:success", function(e, data, status, xhr) {
    $("#invite-form").append(xhr.responseText)
  }).on("ajax:error", function(e, xhr, status, error) {
    $("#invite-form").append("<p>ERROR</p>")
  });
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
