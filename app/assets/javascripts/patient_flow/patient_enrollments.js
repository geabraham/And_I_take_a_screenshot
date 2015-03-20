$('.patient-enrollment').ready(function () {
  var $form = $('#reg-form');
  // landing page - next button
  $('#next-landing').on('click', function(e) {
    $('#landing_page').hide().toggleClass('active');
    $('#tou_dpn_agreement').show().toggleClass('active');
    $('.progress-indicator').removeClass('hidden');
    e.preventDefault();
  });

  // binding Enter key to next button
  $(document).on('keyup', function(e) {
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

      $('#patient_enrollment_login').focus();
    }
  });

  // When the registration form is being submitted via ajax, there is a data-remote="true"
  //  html attribute on the form which means we are in an in-app browser.
  //  This is kind of like being in the matrix in there is a greater dimension
  //  controlling our system.
  // Anyways, if the request to register is successful, we trigger a
  //  registration-complete event to the greater dimension and
  //  if it fails we show the error in plain text.
  //
  $('#reg-form').on("ajax:success", function(e, data, status, xhr) {
    window.location.assign("patient-cloud:registration-complete")
  }).on("ajax:error", function(e, xhr, status, error) {
    $('body').html(xhr.statusText)
  });

  // email
  $('#next-email').on('click', function(e) {
    
    e.preventDefault();
    
    if ($form.valid()) {
      // hide email page
      $('#email').hide().toggleClass('active');
      //show password page
      $('#password').show().toggleClass('active');
  
      progressBar.advance(2);
      addPasswordRules();

      $('#patient_enrollment_password').focus();
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
          $('#create-account').removeClass('disabled');
        } else {
          $('#create-account').addClass('disabled');
        }
      });
      $('#patient_enrollment_security_question').on('change', function() {
        $('#patient_enrollment_answer').val('');
        $('#create-account').addClass('disabled');
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


