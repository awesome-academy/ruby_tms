require "faker"

FactoryBot.define do
  factory :course do
    name {Faker::Name.name}
    description {Faker::Lorem.sentence}
    status {Course.statuses.values.sample}
  end

  trait :pending_course do
    status {Course.statuses[:pending]}
  end

  trait :open_course do
    status {Course.statuses[:open]}
  end

  trait :closed_course do
    status {Course.statuses[:closed]}
  end

  trait :invalid_course do
    name {nil}
  end

  trait :deleted do
    isdeleted {Course.isdeleteds[:deleted]}
  end
end
