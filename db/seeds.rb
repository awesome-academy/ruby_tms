# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
User.create!(name: "admin", email: "admin@gmail.com",
  password: "12345678", role: 1, description: "Administrator - Trainer")

10.times do |n|
  name = Faker::Name.name
  email = "user#{n+1}@gmail.com"
  password = "12345678"
  User.create!(name: name, email: email, password: password,
  description: "Trainee")
end

