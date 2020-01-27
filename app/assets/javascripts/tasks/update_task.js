$(function() {
  $(document).on('click', '.js-taskUpdate', function() {
    // エラーメッセージが存在する場合は消す
    if ($('.alert-danger').length) {
      $('.alert-danger').remove();
    }

    let url = $(this).data('url');
    console.log("url");
    console.log(url);
    let taskId = $(this).data('task-id');
    let taskEditTitle = $(`#js-taskEditTitle-${taskId}`).val();
    let taskEditTweetContent = $(`#js-taskEditBody-${taskId}`).val();
    let taskEditTweetDateYear  = $(`#_js-editTweetDateTime-${taskId}_1i`).val();
    let taskEditTweetDateMonth  = $(`#_js-editTweetDateTime-${taskId}_2i`).val();
    let taskEditTweetDateDay  = $(`#_js-tweet_date-${taskId}_3i`).val();
    let taskEditTweetTimeHour  = $(`#_js-tweet_date-${taskId}_4i`).val();
    let taskEditTweetTimeMinute  = $(`#_js-taskEditTweetTime-${taskId}_5i`).val();
    let taskEditRepeatFlag = 0;
    let sun = 0;
    let mon = 0;
    let tue = 0;
    let wed = 0;
    let thu = 0;
    let fri = 0;
    let sat = 0;

    // yearがundefinedの時、taskは繰り返しであると判定する
    if (taskEditTweetDateYear == undefined) {
      taskEditRepeatFlag = 1;
      if ($(`#js-sun-${taskId}`).prop('checked')) {
        sun = 1;
      }
      if ($(`#js-mon-${taskId}`).prop('checked')) {
        mon = 1;
      }
      if ($(`#js-tue-${taskId}`).prop('checked')) {
        tue = 1;
      }
      if ($(`#js-wed-${taskId}`).prop('checked')) {
        wed = 1;
      }
      if ($(`#js-thu-${taskId}`).prop('checked')) {
        thu = 1;
      }
      if ($(`#js-fri-${taskId}`).prop('checked')) {
        fri = 1;
      }
      if ($(`#js-sat-${taskId}`).prop('checked')) {
        sat = 1;
      }
    }
    $.ajax({
      url: url,
      type:'PUT',
      dataType: "json",
      data:{
        'task': {
          'title': taskEditTitle
          , 'tweet_content': taskEditTweetContent
          , 'repeat_flag': taskEditRepeatFlag
          , 'tweet_date_year': taskEditTweetDateYear
          , 'tweet_date_month': taskEditTweetDateMonth
          , 'tweet_date_day': taskEditTweetDateDay
          , 'tweet_time_hour': taskEditTweetTimeHour
          , 'tweet_time_minute': taskEditTweetTimeMinute
          , 'sun': sun
          , 'mon': mon
          , 'tue': tue
          , 'wed': wed
          , 'thu': thu
          , 'fri': fri
          , 'sat': sat
        }
      }
    })
      .done( (data) => {
        if (taskEditTweetContent !== '') {
        $(`#js-taskTitle-${taskId}`).text(taskEditTitle);
      //   $(`#js-taskBody-${taskId}`).html(taskEditTweetContent.replace(/\r?\n/g, '<br>'));
        $(`#js-taskTweetDateTime-${taskId}`).text(data['tweet_datetime']);
        $(`#js-editTweetContent-${taskId}`).css('display', 'none');
        }
      })
      .fail( (data) => {
      })
    });
  });

