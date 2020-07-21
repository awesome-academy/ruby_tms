$(document).ready(function(){
  $.ajaxSetup({
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
  });

  $(document).on('change','#user_subjects', function(e){
    var tr = $(this).closest("tr");
    var status = $(this).val();
    var button = tr.find('.btn_update_subject');
    var confirm = tr.find('#confirm').val();
    if (status == 'finished'){
      button.attr('data-confirm', confirm)
    }
  });

  $(document).on('click', '.btn_update_subject', function(){
    $(this).attr('disabled', true);
    var tr = $(this).closest("tr");
    var course_id = $('#course_id').val();
    var subject_id = $('#subject_id').val();
    var status = tr.find('#user_subjects').val();

    $.ajax({
      method: 'POST',
      url: '/update_user_subject',
      dataType: 'script',
      data: {
        subject_id: subject_id,
        course_id: course_id,
        status: status
      },
    });
  })
})
