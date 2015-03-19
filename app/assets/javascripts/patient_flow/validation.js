$(function() {
  var $form = $('#reg-form');
  $form.validate({ //initialize the form validator
    errorClass: 'invalid',
    errorPlacement: function(error, element) {
      if (error.text().length > 0) { // prevents overwriting the error message on multiple valid() passes
        $form.find('.active .validation_error').html(error);
        $(element).parent().addClass('invalid');
      }
    },
    rules: {
      'patient_enrollment[login]': {
        required: true,
        email: true
      },
      'patient_enrollment[login_confirmation]' : {
        required: true,
        email: true,
        equalToIgnoreCase: '#patient_enrollment_login' }
    },
    messages: {
        'patient_enrollment[login]': window.t("registration.email_form.validation_error"),
        'patient_enrollment[login_confirmation]': {
          email: window.t("registration.email_form.validation_error"),
          required: window.t("registration.email_form.validation_error"),
          equalToIgnoreCase: window.t("registration.email_form.mismatch_error")}
    },
    success: function(label, element) {
      $(element).parent().removeClass('invalid');
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
        required: window.t("registration.password_form.validation_error"),
        minlength: window.t("registration.password_form.validation_error"),
        pwcheck: window.t("registration.password_form.validation_error")
    }
  });

  $('#patient_enrollment_password_confirmation').rules('add', {
    required: true,
    minlength: 8,
    pwcheck: true,
    equalTo: '#patient_enrollment_password',
    messages: {
      required: window.t("registration.password_form.validation_error"),
      minlength: window.t("registration.password_form.validation_error"),
      pwcheck: window.t("registration.password_form.validation_error"),
      equalTo: window.t("registration.password_form.mismatch_error")
    }
  });

}

var validateSecurityQuestions = function() {
  //custom validation works better than jQuery validate here
  //because there are fewer edge cases and .validate has
  //issues with the rails dropdown

  return ( $.trim($('#patient_enrollment_answer').val() ).length >= 2 &&
          $('#patient_enrollment_security_question').val() !== '');
}

var questionChange = function() {
  if (validateSecurityQuestions() && $('#reg-form').valid()) {
    $('#create-account').removeAttr('disabled').removeClass('disabled');
  } else {
    $('#create-account').attr('disabled', true).addClass('disabled');
  }
}
