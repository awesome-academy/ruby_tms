require "faker"

FactoryBot.define do
  factory :user do
    name {Faker::Name.name}
    email {Faker::Internet.free_email}
    password {Faker::Internet.password}
    description {Faker::Lorem.paragraph}
  end

  trait :trainee do
    role {User.roles[:trainee]}
  end

  trait :trainer do
    role {User.roles[:trainer]}
  end
end
