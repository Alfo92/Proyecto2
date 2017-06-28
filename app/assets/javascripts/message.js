$(function() {
  $('form#new_message').on('ajax:success', function() {
    $(this).hide();
    $('#message_sent_success').fadeIn('slow');
  });
});