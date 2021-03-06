$(document).ready(function(){
  $.ajaxSetup({
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
  });
});

  var previous = '';

  $(document).on('focus', '[name^="select_subject_status"]', function(){
    previous = $(this).val();
  });

  $(document).on('click', '[name^="select_subject_status"]', function(){
    var subject_id = ($(this).parent().find("#subject_id").val());
    var course_id = $('#course_id').val();
    var new_status = $(this).val();

    if (new_status == 'finished'){
      var tr = $(this).closest('tr');
      var message = tr.find('#confirm_update_subject').val();
      var r = confirm(message)
    }

    if (r == false){
      $(this).val(previous);
      return;
    }

    if (new_status != previous){
      $(this).attr('disabled', true);
      $.ajax({
        url: '/admin/update_subject_status',
        type: 'POST',
        dataType: 'script',
        data: {
          status: new_status,
          subject_id: subject_id,
          course_id: course_id
        }
      });
    }
  });
