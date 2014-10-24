// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  $('#select2-1').select2({
    placeholder: 'look up president',
    data: $('#select2-1').data('prez')
  });
  $('#select2-2').select2({
    placeholder: 'look up president',
    data: $('#select2-2').data('prez'),
    formatResult: function(object, container) {
      return $('<div>', {'class': 'row'}).append(
        [$('<div>', {'class': 'col-md-3', text: object.text}),
         $('<div>', {'class': 'col-md-3', text: object.orig.bio.birthday}),
         $('<div>', {'class': 'col-md-3', text: object.orig.terms.length + ' terms'})]
      );
    }
  });
  $('#select2-3').select2({
    placeholder: 'look up president',
    ajax: {
      url: '/sandman/select2_api',
      dataType: 'json',
      data: function(term) {
        return {
          query: term
        };
      },
      results: function(data) {
        return { results: data, more: false }
      }
    }
  });
});
