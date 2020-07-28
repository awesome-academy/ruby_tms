require "faker"

FactoryBot.define do
  factory :user_course do
    role {UserCourse.roles.values.sample}
  end
end
