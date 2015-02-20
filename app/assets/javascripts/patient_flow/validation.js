$(function() {
  $('#reg-form').validate({ //initialize the form validator
    errorPlacement: function(error, element) {
      $('.active .validation_error').html(error);
    },
    rules: {
      'patient_enrollment[login]': {
        required: true,
        email: true
      },
      'patient_enrollment[login_confirmation]' : {
        equalToIgnoreCase: '#patient_enrollment_login' }
    },
    messages: {
        'patient_enrollment[login]': window.I18n.registration.email_form.validation_error,
        'patient_enrollment[login_confirmation]': window.I18n.registration.email_form.mismatch_error
    },
    invalidHandler: function() {
      $('.active .validation_error').removeClass('invisible');
      $('.active .registration-input, .active label').addClass('invalid');
    }
  });

  // validation rule for case insensitive comparison
  $.validator.addMethod("equalToIgnoreCase", function (value, element, param) {
    return value.toUpperCase() === $(param).val().toUpperCase();
  });

  // custom validation for our password rules
  $.validator.addMethod("pwcheck", function(value) {
    return  /[a-z]/.test(value) // has a lowercase letter
      && /[A-Z]/.test(value) // has an uppercase letter
      && /\d/.test(value) // has a digit
      && !(/(  )/.test(value)) //doesn't have consecutive whitespace
      && (value.indexOf(' ') !== 0) //doesn't start with whitespace
      && (value.lastIndexOf(' ') !== value.length - 1); //doesn't end with whitespace
  });
});

var addPasswordRules = function() {
  //add validation rules for password fields
  //this is done dynamically because only part of the larger
  //form is checked at first
  $('#patient_enrollment_password').rules('add', {
    required: true,
    minlength: 8,
    pwcheck: true,
    messages: {
        required: window.I18n.registration.email_form.validation_error,
        minlength: window.I18n.registration.email_form.validation_error,
        pwcheck: window.I18n.registration.email_form.validation_error
    }
  });
  $('#patient_enrollment_password_confirmation').rules('add', {
    equalTo: '#patient_enrollment_password',
    messages: {
        equalTo: window.I18n.registration.email_form.mismatch_error
    }
  });
}
