$(function() {
  $(document).on('change', $('#task_repeat_flag'), function() {
  let isTaskRepeat = $('#task_repeat_flag').prop('checked');
    if (isTaskRepeat) {
      $('#js-wday').fadeIn(250);
      $('#js-tweetTime').fadeIn(250);
      $('#js-tweetDateTime').css('display', 'none');
    } else {
      $('#js-wday').css('display', 'none');
      $('#js-tweetTime').css('display', 'none');
      $('#js-tweetDateTime').fadeIn(250);
    }
  })
})
