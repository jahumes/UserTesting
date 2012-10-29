$(function() {
  $('#users th a').on('click',function() {
    $.getScript(this.href);
    return false;
  });
});