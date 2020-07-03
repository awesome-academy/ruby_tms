Rails.application.routes.draw do
  get 'subjects/new'
  get 'subjects/create'
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/home", to: "static_pages#home", as: :home
    get "/log-in", to: "sessions#new"
    post "/log-in", to: "sessions#create"
    delete "/log-out", to: "sessions#destroy"

    resources :subjects
  end
end
