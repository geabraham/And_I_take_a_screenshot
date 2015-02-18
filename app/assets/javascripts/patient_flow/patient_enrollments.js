$(function () {

  var $form = $('#reg-form');

  // landing page - next button
  $('#next-button').on('click', function(e) {
    e.preventDefault();
    //hide landing page
    $('#landing_page').hide().toggleClass('active');
    //show agreement
    $('#tou_dpn_agreement').show().toggleClass('active');
    $('.progress-indicator').removeClass('hidden');
  });

  // agreement
  $('#agree-button').on('click', function(e) {
    e.preventDefault();
    
    // confirm agreement
    var proceed = confirm("You acknowledge that you have read, understood, and agree to be bound by the Terms of Use and the Privacy Policy referenced herein.");
    if (proceed) {
      // hide agreement page
      $('#tou_dpn_agreement').hide().toggleClass('active');
      //show email page
      $('#email').show().toggleClass('active');
      $('.progress-indicator .step:eq(1)').removeClass('incomplete').addClass('default');
      
      $('#patient_enrollment_login, #patient_enrollment_login_confirmation').on('keyup', function() {
        if($form.valid()) {
          $('#next-email').removeClass('disabled');
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
    $('.progress-indicator .step:eq(2)').removeClass('incomplete').addClass('default');
    addPasswordRules();
    $('#patient_enrollment_password, #patient_enrollment_password_confirmation').on('keyup', function() {
      if($form.valid()) {
        $('#next-password').removeClass('disabled');
      }
    });
  });

  // password
  $('#next-password').on('click', function(e) {
    e.preventDefault();
    $('#password').hide().toggleClass('active');
      //show password page
    $('#security_question').show().toggleClass('active');
    $('.progress-indicator .step:eq(3)').removeClass('incomplete').addClass('default');

    $('#patient_enrollment_answer').on('keyup', function() {
      
    });

  });

  // security question
  $('#create-account').on('click', function(e) {
    
    e.preventDefault();
    console.log('create account')
    // $('#password').hide().toggleClass('active');
      //show password page
    // $('#security_question').show().toggleClass('active');

  });

  // $('.back_arrow').on('click', backClick);

  
  // $('#patient_enrollment_security_question').on('textchange', questionChange);
  
  // $(document).keypress(function(e){
  //     if (e.which == 13){
  //         $("#next-button").click();
  //     }
  // });

});

var validateSecurityQuestions = function() {
  //custom validation works better than jQuery validate here
  //because there are fewer edge cases and .validate has
  //issues with the rails dropdown
  return ($.trim($('#patient_enrollment_answer').val()).length > 0 &&
          $('#patient_enrollment_security_question').val() !== '');
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



  var answerKeyup = function() {

    if (validateSecurityQuestions() && $('#reg-form').valid()) {
      $('#create-account').removeAttr('disabled');
    } else {
      $('#create-account').attr('disabled', 'disabled');
    }
  }

var questionChange = function() {
  if (validateSecurityQuestions() && $('#reg-form').valid()) {
    $('#create-account').removeAttr('disabled').removeClass('disabled');
  } else {
    $('#create-account').attr('disabled', true).addClass('disabled');
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

// ----------------------------------------------------------------------------------------
var progressBar = {
  advance: function() {

  },
  reverse: function() {

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
// ----------------------------------------------------------------------------------------

// var getCurrentPage = function() {
//   return $('.item.active').attr('id')
// }

// var confirmTerms = function() {
//   var proceed = confirm("You acknowledge that you have read, understood, and agree to be bound by the Terms of Use and the Privacy Policy referenced herein.");
  
//   if (proceed === true) {
//     advanceToEmailPage();
//   }
// }

// var advanceToEmailPage = function() {
//   $('#agree-button').addClass('hidden');
//   $('#next-button').removeClass('hidden');
  
//   advanceProgressBar();
//   advanceCarousel();
// }


// var nextButtonClick = function() {
//   var currentPage = getCurrentPage();

//   // carousel = $('.carousel');
  
//   if (currentPage === 'landing_page') {
//     $('#next-button').addClass('hidden');
//     $('#agree-button').removeClass('hidden');
//     $('.progress').removeClass('hidden');
//     advanceCarousel();
//   } else if (currentPage === 'tou_dpn_agreement') {
//     confirmTerms();
//   } else if($('#reg-form').valid()) {
//     hideErrors();
    
//     if(currentPage === 'email') {
//       addPasswordRules();
//       advanceProgressBar();
//       advanceCarousel();
//       $('.back_arrow').removeClass('hidden');
//     } else if(currentPage === 'password') {
//       $('#next-button').addClass('hidden');
//       $('#create-account').removeClass('hidden');
//       advanceProgressBar();
//       advanceCarousel();
//     } else if(currentPage === 'security_question') {
//       $('#create-account').trigger('click');
//     }
//   }
// }
