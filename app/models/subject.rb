class Subject < ApplicationRecord
  # relations:
  belongs_to :user

  # validates:
  validates :name, presence: true
  validates :description, presence: true
  validates :duration, presence: true, numericality: { only_integer: true,
    greater_than_or_equal_to: Settings.subject_form.duration.min}

end
