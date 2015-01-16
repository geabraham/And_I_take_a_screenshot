$(function() {
  $("#patient_management_study").change(function() {
    study_uuid = this.value
    $('#patient_management_study_site').empty()
    $('#patient_management_study_site').append('<option value>Site</option>')

    if (!$.isEmptyObject(study_uuid)) {
      $.getJSON( "/patient_management/sites/" + study_uuid, function(data) {
        $.each(data, function(index, value) {
          $('#patient_management_study_site').append('<option value=' + value[1] + '>' + value[0] + '</option>')
        })
      });
    }
  });
});
