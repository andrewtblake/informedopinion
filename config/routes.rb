Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    confirmations: "users/confirmations"
  }
  get "users/confirmation/pending", to: "users/confirmation_status#show", as: :pending_user_confirmation
  get "users/confirmation/status", to: "users/confirmation_status#status", as: :user_confirmation_status

  root "home#index"
  get "help", to: "pages#help"
  get "methodology", to: "pages#methodology"
  get "privacy", to: "pages#privacy"
  get "terms", to: "pages#terms"
  get "statistics", to: "public_statistics#show", as: :public_statistics
  resource :account, only: %i[show destroy] do
    patch :consent
  end
  resource :stats, only: :show
  resources :fact_question_flags, only: %i[new create], path: "fact-reports"
  resources :opinion_question_proposals, only: %i[index new create], path: "proposals"

  resources :opinion_questions, only: %i[index show], param: :slug, path: "topics" do
    resource :user_opinion, only: %i[create update], path: "opinion"
    resource :reaction, only: %i[create destroy], controller: "opinion_question_reactions"
    resource :quiz, only: :show
    resources :fact_responses, only: :create, path: "answers"
    resources :fact_question_proposals, only: %i[new create], path: "fact-proposals"
  end

  namespace :moderator do
    root "dashboard#index"
    resources :calibration_reviews, only: %i[index show]
    resources :calibration_assessments, only: :update
    resource :heartbeat, only: :show
    resource :moderation_views, only: :create
    resources :fact_question_flags, only: :update
    resources :opinion_question_proposals, only: :update
    resources :fact_question_proposals, only: :update
    resources :featured_questions, only: :update
    resources :opinion_question_reactions, only: :update
    resources :opinion_questions, only: [] do
      resource :publication, only: %i[create destroy], controller: "opinion_question_publications"
      resource :fact_bank, only: :show, controller: "opinion_question_fact_banks"
    end
  end

  namespace :api do
    namespace :v1 do
      resources :opinion_questions, only: %i[index show create update destroy] do
        resources :fact_questions, only: %i[index show create update destroy], shallow: true
        post "fact_questions/bulk", to: "fact_questions#bulk_create", on: :member
        get "calibration_assessments", to: "fact_question_calibration_assessments#index", on: :member
        post "calibration_assessments/bulk", to: "fact_question_calibration_assessments#bulk_create", on: :member
        resource :publication, only: %i[create destroy], controller: "opinion_question_publications"
      end
      resources :moderation_issues, only: %i[index show update] do
        post :approve, on: :member
        post :decline, on: :member
        post :resolve, on: :member
      end
      get "editorial_standard", to: "documentation#editorial_standard"
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
