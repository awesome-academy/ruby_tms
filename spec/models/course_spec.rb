require "rails_helper"

RSpec.describe Course, type: :model do
  it "has a valid factory" do
    FactoryBot.build(:course).should be_valid
  end

  describe "enum" do
    it { is_expected.to define_enum_for(:status).with_values(
      pending: 0,
      open: 1,
      closed: 2
    ) }

    it { is_expected.to define_enum_for(:isdeleted).with_values(
      avaiable: 0,
      deleted: 1,
    ) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(255) }
    it { is_expected.to validate_length_of(:description).is_at_most(255) }
  end

  describe "associations" do
    it { is_expected.to have_many(:users) }
    it { is_expected.to have_many(:user_courses) }
    it { is_expected.to have_many(:course_details) }
    it { is_expected.to have_many(:subjects) }
  end

  describe "scopes" do
    let!(:course_one) {FactoryBot.create(:course, isdeleted: Course.isdeleteds[:deleted], created_at: 2.weeks.ago)}
    let!(:course_two) {FactoryBot.create(:course, isdeleted: Course.isdeleteds[:avaiable], created_at: 1.weeks.ago)}

    it ".newest to sort the courses in descending order created_at" do
      Course.newest.should eq [course_two, course_one]
    end
  end
end
