$(function() {
  $('#user-table').on('click','thead td a, .pagination a',function(event) {
      $.getScript(this.href);
      event.preventDefault();
  });
  $("#user-search input").on('keyup',function() {
      $.get($("#user-search").attr('action'), $("#user-search").serialize(), null, "script");
      return false;
  });
});