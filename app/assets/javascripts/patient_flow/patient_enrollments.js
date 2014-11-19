$('.trigger').popover({
    html: true,
    title: function () {
        return "popover title";
    },
    content: function () {
        return "popover content";
    }
});