namespace :db do
  desc "remake database data"
  task remake_data: :environment do
    %w(db:drop db:create db:migrate).each do |task|
      Rake::Task[task].invoke
    end
    puts "You will be prompted to create data for project."

    # create user trainer:
    User.create!(name: "admin", email: "admin@gmail.com",
      password: "12345678", role: 1, description: "Administrator - Trainer")

    # create user trainee:
    10.times do |n|
      name = Faker::Name.name
      email = "user#{n + 1}@gmail.com"
      password = "12345678"
      User.create!(name: name, email: email, password: password,
      description: "Trainee")
    end

    # create course:
    10.times do |n|
      name = Faker::Name.name
      description = "This is course description of course #{n}"
      Course.create!(name: name, description: description, status: 0, isdeleted: 0)
    end

    # create course user:
    UserCourse.create!(user_id: 1, course_id: 1, role: 0)
    5.times do |n|
      UserCourse.create!(user_id: n + 2, course_id: 1, role: 2)
    end

    # create subject:
    10.times do |n|
      name = Faker::Job.title
      description = "This is subject description of subject #{n}"
      Subject.create!(name: name, duration: n + 1, description: description)
    end

    # create course detail:
    3.times do |n|
      CourseDetail.create!(status: 0, course_id: 1, subject_id: n + 1)
    end

    # create task:
    10.times do |n|
      3.times do |x|
        description = "This is task description #{x + 1} of subject #{n}"
        name = Faker::Name.name
        Task.create!(name: name, description: description, subject_id: n + 1)
      end
    end
  end
end
