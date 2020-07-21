class Subject < ApplicationRecord
  # Author of Subject
  has_many :course_details, dependent: :destroy
  has_many :courses, through: :course_details
  has_many :user_subjects, dependent: :destroy
  has_many :users, through: :user_subjects

  # Relation between Task and User
  has_many :tasks, dependent: :destroy
  accepts_nested_attributes_for :tasks

  # Delegate
  delegate :ids, to: :tasks, prefix: true

  # validates:
  validates :name, presence: true
  validates :description, presence: true
  validates :duration, presence: true,
    numericality: {only_integer: true, greater_than_or_equal_to: Settings.subject_form.duration.min}
  scope :by_name_without_ids, ->(name, not_in){where "name like ? and id not in (?) ", "%#{name}%", not_in}
  scope :sort_by_name, ->{order :name}
  scope :newest, ->{order created_at: :desc}
  scope :search_by_ids, ->(ids){where "id in (?)", ids}
  scope :search_by_name, ->(name){where "name like ?", "%#{name}%"}
end
