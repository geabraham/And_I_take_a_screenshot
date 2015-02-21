$(function () {

  var $form = $('#reg-form');

  // landing page - next button
  $('#next-landing').on('click', function(e) {    
    e.preventDefault();
    $('#landing_page').hide().toggleClass('active');
    $('#tou_dpn_agreement').show().toggleClass('active');
    $('.progress-indicator').removeClass('hidden');
  });

  // agreement
  $('#next-agree').on('click', function(e) {
    e.preventDefault();
    var proceed = confirm("You acknowledge that you have read, understood, and agree to be bound by the Terms of Use and the Privacy Policy referenced herein.");
    if (proceed) {
      // hide agreement page
      $('#tou_dpn_agreement').hide().toggleClass('active');
      //show email page
      $('#email').show().toggleClass('active');
      progressBar.advance(1);
      $('#patient_enrollment_login, #patient_enrollment_login_confirmation').on('keyup', function() {
        if($form.valid()) {
          $('#next-email').removeClass('disabled').focus();
        }
      });
    }
  });

  // email
  $('#next-email').on('click', function(e) {
    
    e.preventDefault();
    
    // hide email page
    $('#email').hide().toggleClass('active');
    
    //show password page
    $('#password').show().toggleClass('active');
    
    // $('.back-arrow').removeClass('hidden');

    progressBar.advance(2);
    // validate password
    addPasswordRules();
    $('#patient_enrollment_password, #patient_enrollment_password_confirmation').on('keyup', function() {
      if($form.valid()) {
        // hideErrors();
        $('#next-password').removeClass('disabled').focus();
      }
    });
  });

  // password
  $('#next-password').on('click', function(e) {
    e.preventDefault();
    $('#password').hide().toggleClass('active');
      //show password page
    $('#security_question').show().toggleClass('active');

    progressBar.advance(3);
    $('#patient_enrollment_security_question').focus()
    $('#patient_enrollment_answer').on('keyup', function() {
      // validate security question
      if (validateSecurityQuestions() && $('#reg-form').valid()) {
        $('#create-account').removeAttr('disabled').removeClass('disabled');
      } else {
        $('#create-account').attr('disabled', true).addClass('disabled');
      }
    });
    $('#patient_enrollment_security_question').on('change', function() {
      $('#patient_enrollment_answer').val('');
      $('#create-account').attr('disabled', true).addClass('disabled');
    });

  });

  $('.back-arrow').on('click', progressBar.reverse);

});


// ----------------------------------------------------------------------------------------


var progressBar = (function() {
  var $slides = $('#registration-details .item'),
      $progressBar = $('.progress-indicator'),
      $progressIndicators = $progressBar.find('.step'),
      slideCount = $slides.length;

  // methods
  var advance =  function(index) {
      $progressIndicators.eq(index)
        .removeClass('incomplete');
    },
    reverse = function() {
      console.log('reverse')
    },
    getCurrentPage = function() {
      return $('.item.active').attr('id');
    };

  return {
    reverse: reverse,
    advance: advance
  }
}());


// ----------------------------------------------------------------------------------------

var validateSecurityQuestions = function() {
  //custom validation works better than jQuery validate here
  //because there are fewer edge cases and .validate has
  //issues with the rails dropdown

  return ( $.trim($('#patient_enrollment_answer').val() ).length >= 4 &&
          $('#patient_enrollment_security_question').val() !== '');
}

var questionChange = function() {
  if (validateSecurityQuestions() && $('#reg-form').valid()) {
    $('#create-account').removeAttr('disabled').removeClass('disabled');
  } else {
    $('#create-account').attr('disabled', true).addClass('disabled');
  }
}
