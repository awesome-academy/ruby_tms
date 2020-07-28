require "rails_helper"
require "spec_helper"
include SessionsHelper

RSpec.describe Admin::CoursesController do

  before do
    trainer = FactoryBot.create(:user, :trainer)
    log_in trainer
  end

  # index method :
  describe "GET #index" do
    let!(:course_one){FactoryBot.create(:course)}
    let!(:course_two){FactoryBot.create(:course)}

    before do
      get :index
    end

    it "populates an array of courses" do
      expect(assigns(:courses)).to eq([course_two, course_one])
    end

    it "renders the #index view" do
      expect(response).to render_template :index
    end

    it "returns a http status 200" do
      expect(response).to have_http_status(200)
    end

    it {should route(:get, "admin/courses").to(action: :index)}
  end

  # show method :
  describe "GET #show" do
    let!(:course){FactoryBot.create(:course)}

    before do
      get :show, params: {id: course}
    end

    it "assign @course" do
      expect(assigns(:course)).to eq(course)
    end

    it "flash message if course is nil" do
      get :show, params: {id: 100}
      expect(flash[:warning]).to eq(I18n.t "courses.load_course.not_found")
    end

    it "renders the #show view" do
      expect(response).to render_template :show
    end

    it "returns a HTTP status 200" do
      expect(response).to have_http_status(200)
    end

    it {should route(:get, "admin/courses/1").to(action: :show, id: 1)}
  end

  # new method :
  describe "GET #new" do
    before do
      get :new
    end

    it "assigns a new course to @course" do
      expect(assigns(:course)).to be_a_new(Course)
    end

    it "renders the #new view" do
      expect(response).to render_template :new
    end

    it "returns a http status 200" do
      expect(response).to have_http_status(200)
    end

    it {should route(:get, "admin/courses/new").to(action: :new)}
  end

  # create method :
  describe "POST #create" do

    context "create a new course success" do
      let!(:trainer){FactoryBot.create(:user, :trainer)}
      let!(:course){FactoryBot.create(:course)}

      it "creates a new course" do
      expect{
        post :create,
        params: {course: FactoryBot.attributes_for(:course)}
      }.to change(Course,:count).by(1)
      end

      it "creates a new user_course" do
        user_course = FactoryBot.create(:user_course, user_id: trainer.id, course_id: course.id)
         expect{
          post :create,
          params: {course: FactoryBot.attributes_for(:course)}
        }.to change(UserCourse,:count).by(1)
      end

      it "flash success message" do
        post :create, params: {course: FactoryBot.attributes_for(:course)}
        expect(flash[:success]).to eq(I18n.t "admin.courses.create.success_message")
      end

      it "redirects to the #index" do
        post :create, params: {course: FactoryBot.attributes_for(:course)}
        expect(response).to redirect_to(admin_courses_path)
      end
    end

    context "create a new course failed" do
      it "does not save the new course" do
        expect{
          post :create,
          params: {course: FactoryBot.attributes_for(:course, :invalid_course)}
        }.to_not change(Course,:count)
      end

      it "re-renders the new method" do
        post :create, params: {course: FactoryBot.attributes_for(:course, :invalid_course)}
        expect(response).to render_template :new
      end

      it "flash failed message" do
        post :create, params: {course: FactoryBot.attributes_for(:course, :invalid_course)}
        expect(flash[:danger]).to eq(I18n.t "admin.courses.create.fail_message")
      end
    end

    it {should route(:post, "admin/courses").to(action: :create)}
  end

  # edit method :
  describe "GET #edit" do
    let!(:course){FactoryBot.create(:course)}

    before do
      get :edit, params: {id: course}
    end

    it "assign @course" do
      expect(assigns(:course)).to eq(course)
    end

    it "renders the #edit view" do
      expect(response).to render_template :edit
    end

    it "returns a http status 200" do
      expect(response).to have_http_status(200)
    end

    it {should route(:get, "admin/courses/1/edit").to(action: :edit, id: 1)}
  end

  # update method :
  describe "PUT #update" do

    before :each do
      @course = FactoryBot.create(:course, :pending_course)
    end

    context "valid attributes" do
      it "located the requested @course" do
        put :update, params: {id: @course, course: FactoryBot.attributes_for(:course, status: :open)}
        expect(assigns(:course)).to eq(@course)
      end

      it "changes @course attributes" do
        put :update, params: {id: @course, course: FactoryBot.attributes_for(:course, status: :open)}
        @course.reload
        @course.status.should eq("open")
      end

      it "flash success message" do
        put :update, params: {id: @course, course: FactoryBot.attributes_for(:course, status: :open)}
        expect(flash[:success]).to eq(I18n.t "admin.courses.edit.success_message")
      end

      it "redirects to the @contact" do
        put :update, params: {id: @course, course: FactoryBot.attributes_for(:course, status: :open)}
        expect(response).to redirect_to [:admin, @course]
      end
    end

    context "invalid attributes" do
      it "located the requested @course" do
        put :update, params: {id: @course, course: FactoryBot.attributes_for(:course, :invalid_course, status: :open)}
        expect(assigns(:course)).to eq(@course)
      end

      it "does not changes @course attributes" do
        put :update, params: {id: @course, course: FactoryBot.attributes_for(:course, :invalid_course, status: :open)}
        @course.reload
        @course.status.should_not eq("open")
        @course.status.should eq("pending")
      end

      it "re-renders the edit method" do
        put :update, params: {id: @course, course: FactoryBot.attributes_for(:course, :invalid_course, status: :open)}
        expect(response).to render_template :edit
      end
    end

    it {should route(:put, "admin/courses/1").to(action: :update, id: 1)}
  end

  # deleted method :
  describe "DELETE #destroy" do
    before :each do
      @course = FactoryBot.create(:course, :pending_course)
    end

    it "deletes the course" do
      expect{ delete :destroy, params: {id: @course, course: FactoryBot.attributes_for(:course,
        isdeleted: Course.isdeleteds[:deleted])} }.to change(Course.avaiable,:count).by(-1)
    end

    it "flash success message" do
      delete :destroy, params: {id: @course, course: FactoryBot.attributes_for(:course, deleted: Course.isdeleteds[:deleted])}
      expect(flash[:success]).to eq(I18n.t "admin.courses.destroy.success")
    end

    it "redirects to the course#index" do
      delete :destroy, params: {id: @course, course: FactoryBot.attributes_for(:course, deleted: Course.isdeleteds[:deleted])}
      expect(response).to redirect_to admin_courses_path
    end

    it {should route(:delete, "admin/courses/1").to(action: :destroy, id: 1)}
  end
end
