// This function helps us manage multiple (sometimes conflicting) JavaScript files
// in Rails by essentially extending $(document).ready() to work with arbitrary
// jQuery selectors, e.g. $('.single-page-content').ready().
// As a result, we are able to maintain the various advantages of requiring JS
// files the Rails way but only execute specific event handlers on certain pages.

(function ($) {
  var ready = $.fn.ready;
  $.fn.ready = function (fn) {
    if (this.context === undefined) {
      // The $().ready(fn) case.
      ready(fn);
    } else if (this.selector) {
      ready($.proxy(function(){
        $(this.selector, this.context).each(fn);
      }, this));
    } else {
      ready($.proxy(function(){
        $(this).each(fn);
      }, this));
    }
  }
})(jQuery);
