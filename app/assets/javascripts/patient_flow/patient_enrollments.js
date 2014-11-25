$(function () {
  $('.carousel').carousel(); //initialize the carousel
  
  $('#reg-form').validate({ //initialize the form validator
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
      console.log('in the invalidHandler');
      $('.validation_error').show();
    }
  })
  
  // custom validation for our password rules
  $.validator.addMethod("pwcheck", function(value) { 
    return  /[a-z]/.test(value) // has a lowercase letter
      && /[A-Z]/.test(value) // has an uppercase letter
      && /\d/.test(value) // has a digit
  });
  
  // custom validation for dropdown
  $.validator.addMethod("question_dd", function(value) {
    return $('#patient_enrollment_security_question').val() !== '';
  });
  
  $('#next-button').on('click', nextButtonClick);
  
  $('.back').on('click', backClick);
  
  $('#patient_enrollment_answer').on('keyup', answerKeyup);
  
  $('#patient_enrollment_security_question').on('change', questionChange);
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

var validateSecurityQuestions = function() {
  //custom validation works better than jQuery validate 
  //because there are fewer edge cases and .validate has
  //issues with the rails dropdown
  return ($('#patient_enrollment_answer').val().length > 0 &&
          $('#patient_enrollment_security_question').val() !== '');
}

var nextButtonClick = function() {
  var currentPage = $('.item.active').attr('id');
  var form = $('#reg-form');
  var carousel = $('.carousel');
  
  //TODO check out how much validation to do here; for now just check length/matching
  if(currentPage === 'email' && form.valid()) {
     carousel.carousel('next');
     addPasswordRules();
  } else if(currentPage === 'password' && form.valid()) {
    carousel.carousel('next');
    $('#next-button').hide();
    $('#submit-button').show(); //TODO need to disable this too?
  } else if(currentPage === 'security_question' && form.valid()) {
    carousel.carousel('next');
  }
}

var backClick = function() {
  var currentPage = $('.item.active').attr('id');
  
  if (currentPage !== 'email') {
    $('.carousel').carousel('prev');
    if (currentPage === 'security_question') {
      $('#submit-button').hide();
      $('#next-button').show();
    }
  }
}

var answerKeyup = function() {
  if (validateSecurityQuestions() && $('#reg-form').valid()) {
    $('#create-account').removeAttr('disabled');
  } else {
    $('#create-account').attr('disabled', 'disabled');
  }
}

var questionChange = function() {
  if (validateSecurityQuestions() && $('#reg-form').valid()) {
    $('#create-account').removeAttr('disabled');
  } else {
    $('#create-account').attr('disabled', 'disabled');
  }
}
