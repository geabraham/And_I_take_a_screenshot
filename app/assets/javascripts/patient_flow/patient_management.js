// Add an on change handler to each dropdown item study and study site.
//
$(function() {
  $("#patient_management_study").on('change', function() {
    study_uuid = this.value;
    clearPopulatedStudySites();

    if (!$.isEmptyObject(study_uuid)) {
      $.getJSON( "/study_sites?study_uuid=" + study_uuid)
      .done(function(studySites) {
        populateStudySitesDropdown(studySites)
      });
    }

    readyForLaunch()
  });

  $('#patient_management_study_site').on('change', readyForLaunch)
});

// Clear study sites populated in the study sites dropdown.
// Called whenever the study dropdown changes.
var clearPopulatedStudySites = function() {
  $('#patient_management_study_site').empty().append('<option value>Site</option>');
}

// Populate the study sites drop down with the list studySites.
// Called whenever the study dropdown changes after studySites are fetched from /study_sites
//
var populateStudySitesDropdown = function(studySites) {
  $.each(studySites, function(index, value) {
    $('#patient_management_study_site').append('<option value=' + value[1] + '>' + value[0] + '</option>')
  });
}

// Gets the values for the selected study and study site options.
// If both are non-null, adds an href attribute and enables the launch button.
// If either one is null, removes the href attribute and disables the launch button.
//
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
  } else {
    $('a#launch-link').removeAttr('href')
    $('input#launch-patient-management').attr('disabled', 'disabled')
  }
}
