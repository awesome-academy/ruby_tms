class UserCourse < ApplicationRecord
  acts_as_paranoid

  enum role: {owner: 0, trainer: 1, trainee: 2}
  belongs_to :user
  belongs_to :course
end
