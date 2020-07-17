class Course < ApplicationRecord
  enum status: {pending: 0, open: 1, closed: 2}
  enum delete_state: {avaiable: 0, deleted: 1}
  # Relation between Course and User
  has_many :user_courses, dependent: :destroy
  has_many :users, through: :user_courses

  # Relation between Course and Subject
  has_many :course_details, dependent: :destroy
  has_many :subjects, through: :course_details

  # Validate
  validates :name, presence: true, length: {maximum: Settings.course.name.max_length}
  validates :description, length: {maximum: Settings.course.name.max_length}
  scope :newest, ->{order created_at: :desc}
  scope :avaiable, ->{where "isdeleted = ?", Course.delete_states[:avaiable]}
end
