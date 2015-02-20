$(function () {
  $('.carousel').carousel(); //initialize the carousel

  $('#next-button, #agree-button').on('click', nextButtonClick);

  $('.back_arrow').on('click', backClick);

  $('#patient_enrollment_answer').on('keyup', answerKeyup);

  $('#patient_enrollment_security_question').on('textchange', questionChange);

  $(document).keypress(function(e){
      if (e.which == 13){
          $("#next-button").click();
      }
  });
});

var validateSecurityQuestions = function() {
  //custom validation works better than jQuery validate here
  //because there are fewer edge cases and .validate has
  //issues with the rails dropdown
  return ($.trim($('#patient_enrollment_answer').val()).length > 0 &&
          $('#patient_enrollment_security_question').val() !== '');
}

var getCurrentPage = function() {
  return $('.item.active').attr('id')
}

var confirmTerms = function() {
    var proceed = confirm(window.I18n.registration.tou_agreement.modal_confirm);

    if (proceed === true) {
        advanceToEmailPage();
    }
}

var advanceToEmailPage = function() {
  $('#agree-button').addClass('hidden');
  $('#next-button').removeClass('hidden');

  advanceProgressBar();
  advanceCarousel();
}

var advanceCarousel = function () {
  $('.carousel').carousel('next');

  //fix for mobile field focus cutting off top of page
  window.scrollTo(0, 0);
  document.body.scrollTop = 0;
}

var nextButtonClick = function() {
  var currentPage = getCurrentPage(),
  carousel = $('.carousel');

  if (currentPage === 'landing_page') {
    $('#next-button').addClass('hidden');
    $('#agree-button').removeClass('hidden');
    $('.progress').removeClass('hidden');
    advanceCarousel();
  } else if (currentPage === 'tou_dpn_agreement') {
    confirmTerms();
  } else if($('#reg-form').valid()) {
    hideErrors();

    if(currentPage === 'email') {
      addPasswordRules();
      advanceProgressBar();
      advanceCarousel();
      $('.back_arrow').removeClass('hidden');
    } else if(currentPage === 'password') {
      $('#next-button').addClass('hidden');
      $('#create-account').removeClass('hidden');
      advanceProgressBar();
      advanceCarousel();
    } else if(currentPage === 'security_question') {
      $('#create-account').trigger('click');
    }
  }
}

var backClick = function() {
  var currentPage = getCurrentPage();

  if (currentPage !== 'landing_page' && currentPage !== 'tou_dpn_agreement' && currentPage !== 'email') {
    //TODO currently we are validating on back button click
    //to prevent a confusing UX issue where the error message
    //disappears (on back click) and cannot be restored
    //unless the form is corrected and rebroken
    //there might be a better workaround, discuss
    if($('#reg-form').valid() || isBlankEntry()) {
      hideErrors();
      reverseProgressBar();
      $('.carousel').carousel('prev');
      if (currentPage === 'password') {
        $('.back_arrow').addClass('hidden');
      } else if (currentPage === 'security_question') {
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
  return (($('.active .registration-input').first().val().length === 0)
       && ($('.active .registration-input').last().val().length === 0));
}
