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
  
  $.validator.addMethod("pwcheck", function(value) {
    return  /[a-z]/.test(value) // has a lowercase letter
      && /[A-Z]/.test(value) // has an uppercase letter
      && /\d/.test(value) // has a digit
  });
  
  $('#next-button').click(function() {
    var currentPage = $('.item.active').attr('id');
    var form = $('#reg-form');
    var carousel = $('.carousel');
    
    //TODO check out how much validation to do here; for now just check length/matching
    if(currentPage === 'email' && form.valid()) {
       carousel.carousel('next');
       addPasswordRules();
    } else if(currentPage === 'password' && form.valid()) {
      carousel.carousel('next');
    } else if(currentPage === 'security_question' && form.valid()) {
      carousel.carousel('next');
    }
  })
})

var addPasswordRules = function() {
  //add validation rules for password fields
  //this is done dynamically because only part of the larger
  //form is checked at first
  $('#patient_enrollment_password').rules('add', {
    required: true,
    minlength: 8,
    pwcheck: true,
    messages: {
      required: 'Enter a valid password.',
      minlength: 'Enter a valid password.',
      pwcheck: 'Enter a valid password.'
    }
  });
  $('#patient_enrollment_password_confirmation').rules('add', {
    equalTo: '#patient_enrollment_password',
    messages: {
      equalTo: 'Your passwords do not match.'
    }
  });
}