class CourseDetail < ApplicationRecord
  enum status: {pending: 0, open: 1, finished: 2}
  belongs_to :course
  belongs_to :subject
end
