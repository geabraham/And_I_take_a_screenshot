// Add an on change handler to each dropdown item study and study site.
//
$(function() {
  var requiredFields = [
    '#_patient_management_invite_subject_identifier',
    '#_patient_management_invite_country_language'
  ]
  _.each(requiredFields, function(field) {
    $(field).on('change', function() { return inviteButtonEnabledDisabled(); })
  })
});

var inviteButtonEnabledDisabled = function() {
  var subject = $('#_patient_management_invite_subject_identifier option:selected')[0].value
  var languageCountryPair = $('#_patient_management_invite_country_language option:selected')[0].value

  if(!$.isEmptyObject(subject) && !$.isEmptyObject(languageCountryPair)) {
    $('input#invite-button').prop('disabled', false)
  } else {
    $('input#invite-button').attr('disabled', 'disabled')
  }
}
