$(function() {
  $(document).on('click', '.js-taskUpdate', function() {
    // エラーメッセージが存在する場合は消す
    if ($('.alert-danger').length) {
      $('.alert-danger').remove();
    }

    let url = $(this).data('url');
    let taskId = $(this).data('task-id');
    let taskEditTitle = $(`#js-editTitle-${taskId}`).val();
    let taskEditTweetContent = $(`#js-editTweetContent-${taskId}`).val();
    let taskEditRepeatFlag = 0;
    // 繰り返しなしのタスク用変数
    let taskEditTweetYear  = $(`#_js-editTweetDateTime-${taskId}_1i`).val();
    let taskEditTweetMonth  = $(`#_js-editTweetDateTime-${taskId}_2i`).val();
    let taskEditTweetDay  = $(`#_js-editTweetDateTime-${taskId}_3i`).val();
    let taskEditTweetHour  = $(`#_js-editTweetDateTime-${taskId}_4i`).val();
    let taskEditTweetMinute  = $(`#_js-editTweetDateTime-${taskId}_5i`).val();
    // 繰り返しタスク用変数
    let taskEditRepeatHour  = $(`#_js-editTweetTime-${taskId}_4i`).val();
    let taskEditRepeatMinute  = $(`#_js-editTweetTime-${taskId}_5i`).val();
    let sun;
    let mon;
    let tue;
    let wed;
    let thu;
    let fri;
    let sat;

    // yearがundefinedの時、taskは繰り返しであると判定する
    if (taskEditTweetYear == undefined) {
      taskEditRepeatFlag = 1;
      if ($(`#js-sun-${taskId}`).prop('checked')) {
        sun = 1;
      } else {
        sun = 0;
      }
      if ($(`#js-mon-${taskId}`).prop('checked')) {
        mon = 1;
      } else {
        mon = 0;
      }
      if ($(`#js-tue-${taskId}`).prop('checked')) {
        tue = 1;
      } else {
        tue = 0;
      }
      if ($(`#js-wed-${taskId}`).prop('checked')) {
        wed = 1;
      } else {
        wed = 0;
      }
      if ($(`#js-thu-${taskId}`).prop('checked')) {
        thu = 1;
      } else {
        thu = 0;
      }
      if ($(`#js-fri-${taskId}`).prop('checked')) {
        fri = 1;
      } else {
        fri = 0
      }
      if ($(`#js-sat-${taskId}`).prop('checked')) {
        sat = 1;
      } else {
      sat = 0;
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
          , 'tweet_year': taskEditTweetYear
          , 'tweet_month': taskEditTweetMonth
          , 'tweet_day': taskEditTweetDay
          , 'tweet_hour': taskEditTweetHour
          , 'tweet_minute': taskEditTweetMinute
          , 'repeat_hour': taskEditRepeatHour
          , 'repeat_minute': taskEditRepeatMinute
          , 'tweet_sun': sun
          , 'tweet_mon': mon
          , 'tweet_tue': tue
          , 'tweet_wed': wed
          , 'tweet_thu': thu
          , 'tweet_fri': fri
          , 'tweet_sat': sat
        }
      }
    })
      .done( (data) => {
        $(`#js-taskTitle-${taskId}`).text(taskEditTitle);
        $(`#js-tweetContent-${taskId}`).html(taskEditTweetContent.replace(/\r?\n/g, '<br>'));
        $(`#js-nextTweetDatetime-${taskId} strong`).text(data['tweet_datetime']);
        if (data['repeat']) {
          let wdays = ['日', '月', '火', '水', '木', '金', '土'];
          $(`#js-repeatTweetTime-${taskId}`).text(data['repeat_tweet_time']);
          let wdaysHtml = '';
          for (var i = 0; i < data['wdays'].length; i++) {
            if (data['wdays'][i] == 1) {
            wdaysHtml += `<span class='mr-2'>${wdays[i]}</span>`;
            }
          }
          $(`#js-repeatWdays-${taskId}`).html(wdaysHtml);
        }
        $(`#js-taskEditForm-${taskId}`).fadeOut(250);
        $(`#js-task-flash-${taskId}`).html('<div class="alert alert-success py-1 time-out">タスクを更新しました</div>');
      })
      .fail( (data) => {
        $(`#js-task-flash-${taskId}`).html(`<div class="alert alert-danger py-1 time-out">${data['responseJSON']['errors']['messages']}</div>`);
      })
    });
  });

