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
      $('.validation_error').show();
      $('.active .registration-input, .active label').addClass('invalid');
    }
  })
  
  // custom validation for our password rules
  $.validator.addMethod("pwcheck", function(value) { 
    return  /[a-z]/.test(value) // has a lowercase letter
      && /[A-Z]/.test(value) // has an uppercase letter
      && /\d/.test(value) // has a digit
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
  //custom validation works better than jQuery validate here
  //because there are fewer edge cases and .validate has
  //issues with the rails dropdown
  return ($('#patient_enrollment_answer').val().length > 0 &&
          $('#patient_enrollment_security_question').val() !== '');
}

var nextButtonClick = function() {
  var currentPage = $('.item.active').attr('id');
  var carousel = $('.carousel');
  
  if($('#reg-form').valid()) {
    hideErrors();
    carousel.carousel('next');
    if(currentPage === 'email') {
      addPasswordRules();
    } else if(currentPage === 'password') {
      $('#next-button').hide();
      $('#submit-button').show();
    }
  }
}

var backClick = function() {
  if($('#reg-form').valid() || isBlankEntry()) {
    hideErrors();
    var currentPage = $('.item.active').attr('id');
    
    if (currentPage !== 'email') {
      $('.carousel').carousel('prev');
      if (currentPage === 'security_question') {
        $('#submit-button').hide();
        $('#next-button').show();
      }
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

var hideErrors = function() {
  $('.validation_error').hide();
  $('.active .registration-input, .active label').removeClass('invalid');
}

var isBlankEntry = function() {
  return (($('.active .registration-input').first().val().length == 0) 
       && ($('.active .registration-input').last().val().length == 0));
}
