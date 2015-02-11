// Add an on change handler to each dropdown item study and study site.
//
$(function() {
  var requiredFields = ['#patient_enrollment_subject', '#patient_enrollment_country_language']

  _.each(requiredFields, function(field) {
    $(field).on('change', function() { return inviteButtonEnabledDisabled(); })
  })

  $("#invite-form").on("ajax:success", function(e, data, status, xhr) {
    console.log(e)
    console.log(data)
    console.log(status)
    console.log(xhr)
    resetErrors()
    requestAvailableSubjects();
  }).on("ajax:error", function(e, xhr, status, error) {
    resetErrors()
    $("#invite-form-error").removeClass('hidden')
    $("#invite-form-error span.message").append(xhr.responseText)
    requestAvailableSubjects();
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

var requestAvailableSubjects = function() {
  var queryObj = {}
  var querystring = location.search.replace('?', '').split('&');
  for (var i = 0; i < querystring.length; i++) {
      var name = querystring[i].split('=')[0];
      var value = querystring[i].split('=')[1];
      queryObj[name] = value;
  }
  $.getJSON('/patient_management/available_subjects?study_uuid=' + queryObj.study_uuid + '&study_site_uuid=' + queryObj.study_site_uuid)
  .done(function(availableSubjects) {
    $('#patient_enrollment_subject').empty().append('<option value>Subject</option>');
    var options = ''
    $.each(availableSubjects, function(index, value) {
      options += '<option value=' + value[1] + '>' + value[0] + '</option>'
    });
    $('#patient_enrollment_subject').append(options)
  });
}
