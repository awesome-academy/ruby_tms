class ProcessTask < ApplicationRecord
  after_update :auto_update_user_subject

  enum status: {pending: 0, in_processing: 1, finished: 2}
  belongs_to :user
  belongs_to :task
  has_many :histories, dependent: :destroy

  scope :count_finished, ->(task_ids){where "status = ? and task_id IN (?)", ProcessTask.statuses[:finished], task_ids}

  def auto_update_user_subject
    f_subject = task.subject
    f_task_ids = f_subject.tasks_ids
    f_user_subject = UserSubject.find_by subject_id: f_subject.id, user_id: user_id
    count_process_tasks = f_task_ids.size
    count_process_tasks_finish = ProcessTask.count_finished(f_task_ids).size
    f_user_subject.update!(status: UserSubject.statuses[:finished]) if count_process_tasks == count_process_tasks_finish
  end
end
