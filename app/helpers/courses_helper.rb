module CoursesHelper
  def statuses_generator
    Course.statuses.map{|key, _value| [Course.human_enum_name(:status, key), key]}
  end

  def subject_detail_statuses_generator
    CourseDetail.statuses.map{|key, _value| [CourseDetail.human_enum_name(:status, key), key]}
  end

  def statuses_generator_subject
    UserSubject.statuses.map{|key, _value| [UserSubject.human_enum_name(:status, key), key]}
  end

  def trainee_check_process_task_finished subject, current_user
    task_ids = subject.tasks.ids
    count_process_task = task_ids.size
    count_process_task_finish = current_user.process_tasks.count_finished(task_ids).size
    count_process_task == count_process_task_finish ? "" : I18n.t("courses.show.all_task_not_finish")
  end

  def count_user course
    user_in_course_ids = course.users.ids
    count_user_in_course = user_in_course_ids.size
    count_user_finished_subject_in_course = UserSubject.check_exist(user_in_course_ids).finished.size
    I18n.t("admin.courses.show.all_subject_not_finish") unless count_user_in_course == count_user_finished_subject_in_course
  end
end
