Rails.application.routes.draw do
  get '/ping' => 'main#ping'

  root to: 'haikus#index'
end
