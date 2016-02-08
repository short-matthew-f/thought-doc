Rails.application.routes.draw do
  resources :votes
  root to: 'application#index'

  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/auth', to: 'sessions#destroy', as: :sign_out

  resources :lessons, shallow: true do
    resources :polls, shallow: true do
      post '/toggle', to: 'polls#toggle', as: :toggle
      get '/stats', to: 'polls#stats', as: :stats

      resources :choices do
        post '/mark_correct', to: 'choices#mark_correct', as: :mark_correct
      end
    end
  end


  get '/students/:lesson_token', to: 'students#lesson', as: :student_lesson
  get '/students/:lesson_token/pending', to: 'students#pending'
  get '/students/:lesson_token/finished', to: 'students#finished'
  post '/students/:choice_id/vote', to: 'students#vote', as: :student_vote
end
