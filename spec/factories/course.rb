require "faker"

FactoryBot.define do
  factory :course do
    name {Faker::Name.name}
    description {Faker::Lorem.paragraph}
    status {Course.statuses.values.sample}
  end
end
