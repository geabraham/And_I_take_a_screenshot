$(function () {
  $('.carousel').carousel();
  
  $('#reg-form').validate({
    errorPlacement: function(error, element) {
      $('.active .validation_error').html(error);
    },
    rules: { //TODO add validation for email address
      'patient_enrollment[login]': {
        required: true,
        email: true
      },
      'patient_enrollment[login_confirmation]' : {
        equalTo: '#patient_enrollment_login' }
    },
    messages: {
      'patient_enrollment[login]': 'Enter a valid email.',
      'patient_enrollment[login_confirmation]': 'Your Emails do not match.'
    },
    invalidHandler: function() {
      $('.validation_error').show();
    }
  })
  
  $('#next-button').click(function() {
    var currentPage = $('.item.active').attr('id');
    
    //TODO check out how much validation to do here; for now just check length/matching
    if(currentPage === 'email' && $('#reg-form').valid()) {
       $('.carousel').carousel('next');
    } else if(currentPage === 'password' && validatePassword()) {
      $('.carousel').carousel('next');
    } else if(currentPage === 'security_question' && validateSecurityQuestion()) {
      $('.carousel').carousel('next');
    }
  })
})