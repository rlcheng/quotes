Rails.application.routes.draw do
  get '/ping' => 'main#ping'
  resources :users, defaults: {format: :json}

  root to: 'haikus#index'
end
