Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    devise_scope :user do
      get "/log-in", to: "devise/sessions#new"
      post "/log-in", to: "devise/sessions#create"
      get "/register", to: "devise/registrations#new"
      delete "/log-out", to: "devise/sessions#destroy"
    end

    devise_for :users

    get "/home", to: "static_pages#home"

    namespace :admin do
      get "/search_user_by_name", to: "searchs#search_user_by_name"
      post "/add_existing_user_to_course", to: "user_courses#create"
      get "/search_subject_by_name", to: "searchs#search_subject_by_name"
      post "/add_subject_by_name", to: "course_details#create"
      post "/update_subject_status", to: "course_details#update"

      resources :subjects, except: :destroy do
          resources :tasks, only: %i(show edit update)
      end
      resources :courses do
        resources :users, except: :destroy do
          resources :user_subjects, only: %i(index)
        end
      end
      resources :user_courses, only: :create
    end

    post "/update_process_task", to: "process_tasks#update"
    post "/update_user_subject", to: "user_subjects#update"
    resources :courses, only: :show do
      resources :subjects, only: :show do
        resources :tasks, only: :show
      end
    end

    resources :user_subjects, only: %i(create update)
    resources :process_tasks, only: :update
  end
end
