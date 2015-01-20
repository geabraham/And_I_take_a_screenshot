$(function() {
  $("#patient_management_study").on('change', function() {
    study_uuid = this.value;
    clearPopulatedStudySites();

    if (!$.isEmptyObject(study_uuid)) {
      $.getJSON( "/patient_management/sites/" + study_uuid)
      .done(function(studySites) {
        populateStudySitesDropdown(studySites)
      });
    }

    readyForLaunch()
  });

  $('#patient_management_study_site').on('change', readyForLaunch)
});

var clearPopulatedStudySites = function() {
  $('#patient_management_study_site').empty().append('<option value>Site</option>');
}

var populateStudySitesDropdown = function(studySites) {
  $.each(studySites, function(index, value) {
    $('#patient_management_study_site').append('<option value=' + value[1] + '>' + value[0] + '</option>')
  });
}

var readyForLaunch = function() {
  study_uuid = $('#patient_management_study option:selected')[0].value
  if ($('#patient_management_study_site option:selected')[0]) {
    study_site_uuid = $('#patient_management_study_site option:selected')[0].value
  } else {
    study_site_uuid = null
  }

  if(!$.isEmptyObject(study_uuid) && !$.isEmptyObject(study_site_uuid)) {
    $('a#launch-link').attr('href', '/patient_management?study_uuid=' + study_uuid + '&study_site_uuid=' + study_site_uuid)
    $('input#launch-patient-management').removeAttr('disabled')
  } else if(!$('input#launch-patient-management').attr('disabled')) {
    $('a#launch-link').removeAttr('href')
    $('input#launch-patient-management').attr('disabled', 'disabled')
  }
}
