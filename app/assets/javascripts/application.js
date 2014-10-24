// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery_ujs
//= require_tree .

$(function() {
  $('#medidations').on('click', 'td', function(e) {
    if( e.target.tagName !== 'TD') return;
    location = $(this).parents('tr').data('action');
    e.preventDefault();
  });

  $('.search-dropdown').on('click', 'a[data-value]', function () {
    var parseAttr = function (data) {
      return data.split('_').map(function (val) {
        return val === 'id' ? 'ID' : val[0].toUpperCase() + val.substr(1).toLowerCase();
      }).join(' ');
    };

    var searchAttr = 'Search by ' + parseAttr($(this).attr('data-value'));

    $(this).closest('.search-dropdown').find('.search-dropdown-text').html(searchAttr);
  });
});
