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
      $('.active .validation_error').removeClass('invisible');
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
  
  $('.back_arrow').on('click', backClick);
  
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
  $('a#next-button').text('Next')

  var currentPage = $('.item.active').attr('id'),
  carousel = $('.carousel');
  
  if($('#reg-form').valid()) {
    hideErrors();
    advanceProgressBar();
    carousel.carousel('next');
    if(currentPage === 'email') {
      addPasswordRules();
    } else if(currentPage === 'password') {
      $('#next-button').addClass('hidden');
      $('#create-account').removeClass('hidden');
    }
  }
}

var backClick = function() {
  //TODO currently we are validating on back button click
  //to prevent a confusing UX issue where the error message
  //disappears (on back click) and cannot be restored
  //unless the form is corrected and rebroken
  //there might be a better workaround, discuss
  if($('#reg-form').valid() || isBlankEntry()) {
    hideErrors();
    var currentPage = $('.item.active').attr('id');
    
    if (currentPage !== 'email') {
      reverseProgressBar();
      $('.carousel').carousel('prev');
      if (currentPage === 'security_question') {
        $('#create-account').addClass('hidden');
        $('#next-button').removeClass('hidden');
      }
    }
  }
}

var advanceProgressBar = function() {
  $('.progress-bar-incomplete').first().addClass('progress-bar-default');
  $('.progress-bar-incomplete').first().removeClass('progress-bar-incomplete');
}

var reverseProgressBar = function() {
  $('.progress-bar-default').last().addClass('progress-bar-incomplete');
  $('.progress-bar-default').last().removeClass('progress-bar-default');
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
  $('.active .validation_error').addClass('invisible');
  $('.active .registration-input, .active label').removeClass('invalid');
}

var isBlankEntry = function() {
  return (($('.active .registration-input').first().val().length == 0) 
       && ($('.active .registration-input').last().val().length == 0));
}
