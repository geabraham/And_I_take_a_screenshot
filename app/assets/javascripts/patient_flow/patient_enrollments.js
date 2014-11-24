$(function () {
  $('.carousel').carousel();
  
  $('#next-button').click(function() {
    var currentPage = $('.item.active').attr('id');
    
    if(currentPage === 'email' && validateEmail()) {
      $('.carousel').carousel('next');
    } else if(currentPage === 'password' && validatePassword()) {
      $('.carousel').carousel('next');
    } else if(currentPage === 'security_question' && validateSecurityQuestion()) {
      $('.carousel').carousel('next');
    }
  })
})

var validateEmail = function () {
  return true;
}

var validatePassword = function () {
  return true;
}

var validateSecurityQuestion = function () {
  return true;
}