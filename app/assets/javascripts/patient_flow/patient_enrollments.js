$(function () {
  $('.carousel').carousel();
  
  $('#reg-form').validate({
    debug: true,
    rules: {
      'patient_enrollment[login]': 'required'
    },
    messages : {
      'patient_enrollment[login]': 'Please specify an email or whatever.'
    }
  })
  
  $('#next-button').click(function() {
    var currentPage = $('.item.active').attr('id');
    
    if(currentPage === 'email') {
      validateEmail();
    } else if(currentPage === 'password' && validatePassword()) {
      $('.carousel').carousel('next');
    } else if(currentPage === 'security_question' && validateSecurityQuestion()) {
      $('.carousel').carousel('next');
    }
  })
})

var validateEmail = function () {
  //TODO check out how much validation to do here; for now just check length/matching
  $('#reg-form').valid();
}

var validatePassword = function () {
  return true;
}

var validateSecurityQuestion = function () {
  return true;
}

var showValidationError = function () {
  $('.active .validation_error').show();
}