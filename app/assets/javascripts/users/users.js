$(function() {
  $('#user-table').on('click','thead td.sorting',function(event) {
      var href = $(this).children('a').attr('href');
      $.getScript(href);
      event.preventDefault();
  });
    $('#user-table').on('click','.pages a',function(event) {
        $.getScript(this.href);
        event.preventDefault();
    });
  $("#user-search input").on('keyup',function() {
      $('#user-per-page #per-page-search').val($(this).val());
      $.get($("#user-search").attr('action'), $("#user-search").serialize(), null, "script");
      return false;
  });
    $("#user-per-page select").on('change',function() {
        $('#user-search #search-per-page').val($(this).val());
        $.get($("#user-per-page").attr('action'), $("#user-per-page").serialize(), null, "script");
        return false;
    });
    $('.delete_user').on('ajax:success', function() {
        $.getScript('/users');
    });
    $('select.multiple-token').chosen({
        width: '100%'
    });
});
