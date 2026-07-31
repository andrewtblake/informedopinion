Rails.application.routes.draw do
  devise_for :users

  root "home#index"
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
    resources :fact_question_flags, only: :update
    resources :opinion_question_proposals, only: :update
    resources :fact_question_proposals, only: :update
    resources :featured_questions, only: :update
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
