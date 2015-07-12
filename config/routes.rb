SunstoneCal::Application.routes.draw do
  resources :studios

  root to: 'studios#index'
end
