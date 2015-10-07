Rails.application.routes.draw do
  get '/ping' => 'main#ping'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/auth/failure' => 'sessions#auth_failed'
  delete '/sessions/:id' => 'sessions#destroy'
  resources :users, defaults: {format: :json}

  root to: 'haikus#index'
end
