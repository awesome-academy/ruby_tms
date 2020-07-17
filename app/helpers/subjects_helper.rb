module SubjectsHelper
  def edit_action?
    action_name == "edit"
  end

  def trainee_show_subject_status
    @subject.course_details.find_by(course_id: params[:course_id]).status
  end
end
