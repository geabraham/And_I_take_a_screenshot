$(function () {
  var $form = $('#reg-form');
  // landing page - next button
  $('#next-landing').on('click', function(e) {
    $('#landing_page').hide().toggleClass('active');
    $('#tou_dpn_agreement').show().toggleClass('active');
    $('.progress-indicator').removeClass('hidden');
    e.preventDefault();
  });

  // binding Enter key to next button
  $(document).on('keypress', function(e) {
    if (e.which === 13) {
      $('.active .btn').click();
    }
  });

  // agreement
  $('#next-agree').on('click', function(e) {
    e.preventDefault();
    var proceed = confirm(window.t("registration.tou_agreement.modal_confirm"));
    if (proceed) {
      
      // hide agreement page
      $('#tou_dpn_agreement').hide().toggleClass('active');
      //show email page
      $('#email').show().toggleClass('active');
      
      progressBar.advance(1);
    }
  });

  // email
  $('#next-email').on('click', function(e) {
    
    e.preventDefault();
    
    if ($form.valid()) {
      // hide email page
      $('#email').hide().toggleClass('active');
      //show password page
      $('#password').show().toggleClass('active');
      
      // $('.back-arrow').removeClass('hidden');
  
      progressBar.advance(2);
      addPasswordRules();
    }
  });

  // password
  $('#next-password').on('click', function(e) {
    e.preventDefault();

    if ($form.valid()) {
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
    }
  });

  $('.back-arrow').on('click', progressBar.reverse);

  $('#reg-form').on('submit', function() {
    $('#create-account').addClass('disabled');
    $('#patient_enrollment_security_question').addClass('disabled');
    $('#patient_enrollment_answer').addClass('disabled');
  });
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


