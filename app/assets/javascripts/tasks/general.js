$(function() {
  $(document).on('click', '.js-showMoreInfo', function() {
    let taskId = $(this).data('task-id');
    $(`#js-moreInfo-${taskId}`).slideDown(500);
    $(`#js-hideIcon-${taskId}`).fadeOut(250);
  });
  $(document).on('click', '.js-hideMoreInfo', function() {
    let taskId = $(this).data('task-id');
    $(`#js-moreInfo-${taskId}`).slideUp(500);
    setTimeout(function() {
      $(`#js-hideIcon-${taskId}`).css('display', 'block');
    }, 300);
  });
});
