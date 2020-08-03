class User < ApplicationRecord
  enum role: {trainee: 0, trainer: 1}

  # Relation between User and Course
  has_many :user_courses, dependent: :destroy
  has_many :courses, through: :user_courses

  # Relation between User and Report
  has_many :reports, dependent: :destroy

  # Relation between User and process task
  has_many :process_tasks, dependent: :destroy
  has_many :tasks, through: :process_tasks

  # Relation between User and Subject
  has_many :user_subjects, dependent: :destroy
  has_many :subjects, through: :user_subjects

  # Delegate
  delegate :ids, to: :courses, prefix: true

  validates :name, presence: true

  # scope:
  scope :sort_by_name_role, ->{order(:name, :role)}
  scope :search_by_name_and_not_in_course, ->(name, not_in){where "name like ? and id not in (?) ", "%#{name}%", not_in}
  scope :search_not_in_course, ->(not_in){where "id not in (?)", not_in}
  scope :search_by_ids, ->(ids){where "id in (?)", ids}

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :validatable
end
