$(function() {
  $( "#patient_management_study" ).change(function() {
    study_uuid = this.value
    studies = $.getJSON( "patient_management/sites/" + study_uuid, function(data) {
      $.each(data, function(index, value) {
        $('#patient_management_study_site').append('<option value=' + value[1] + '>' + value[0] + '</option>')
      })
    });
  });
});