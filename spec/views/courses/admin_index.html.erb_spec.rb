require "rails_helper"
require "spec_helper"
include SessionsHelper

RSpec.describe "admin/courses/index.html.erb" do
  before (:each) do
    trainer = FactoryBot.create(:user, :trainer)
    log_in trainer

    course_one = FactoryBot.create(:course, :avaiable, name: "course_one")
    course_two = FactoryBot.create(:course, :avaiable, name: "course_two")

    assign(:courses, [
      course_one, course_two
    ])

    allow(view).to receive_messages(will_paginate: nil)
    view.lookup_context.view_paths.push "app/views/admin"
  end

  it "renders the _course partial for each course" do
    render

    view.should render_template(partial: "_course")
  end

  it "display all courses" do
    render

    view.should render_template(partial: "_course", count: 2)
  end

  it "display correct content of a course" do
    render

    expect(rendered).to match /course_one/
    expect(rendered).to match /course_two/
  end

  it "displays the given text" do
    render plain: I18n.t("admin.courses.visit.title")

    expect(rendered).to match I18n.t("admin.courses.visit.title")
  end

  it "check admin access" do
    render

    expect(rendered).to have_selector("a", text: I18n.t("admin.courses.destroy.link_delete_text") )
  end

  it "has a request.fullpath that is defined" do
    expect(controller.request.fullpath).to eq admin_courses_path
  end
end
