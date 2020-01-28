$(function() {
  $(document).on('click', '.js-taskEdit', function() {
    let taskId = $(this).data('task-id');
    let taskEditForm = $(`#js-taskEditForm-${taskId}`);

    let taskEditTweetContentArea = $(`#js-editTweetContent-${taskId}`);
    let taskTweetContent = $(`#js-tweetContent-${taskId}`).text();

    let taskEditTitleArea = $(`#js-editTitle-${taskId}`);
    let taskTitle = $(`#js-taskTitle-${taskId}`).text();

    let taskEditTweetDateTimeArea = $(`#js-taskEditTweetDateTime-${taskId}`);
    let taskTweetDateTime = $(`#js-taskTweetDateTime-${taskId}`).text();

    if (taskEditForm.css('display') === 'none') {
      // taskEditForm.css('display', 'block')
      taskEditForm.slideDown(500);
      taskEditTitleArea.val(taskTitle)
      taskEditTweetContentArea.val(taskTweetContent)

      // ツイートする日時(yyyy-MM-dd hh:mm)が表示されていない場合は、repeat_tweetとみなす
      if ($(`#js-tweetTiming-${taskId}`).text().indexOf('-') === -1) {
        let wdayText = $(`#js-tweetTiming-${taskId} span`).text();
        if (wdayText.indexOf('日') !== -1) {
          $(`#js-sun-${taskId}`).prop('checked', true);
        }
        if (wdayText.indexOf('月') !== -1) {
          $(`#js-mon-${taskId}`).prop('checked', true);
        }
        if (wdayText.indexOf('火') !== -1) {
          $(`#js-tue-${taskId}`).prop('checked', true);
        }
        if (wdayText.indexOf('水') !== -1) {
          $(`#js-wed-${taskId}`).prop('checked', true);
        }
        if (wdayText.indexOf('木') !== -1) {
          $(`#js-thu-${taskId}`).prop('checked', true);
        }
        if (wdayText.indexOf('金') !== -1) {
          $(`#js-fri-${taskId}`).prop('checked', true);
        }
        if (wdayText.indexOf('土') !== -1) {
          $(`#js-sat-${taskId}`).prop('checked', true);
        }
      }
    } else {
      taskEditForm.slideUp(500);
    }
  });
});
