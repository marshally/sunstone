SunstoneCal::Application.routes.draw do
  resources :studios do
    member do
      get 'schedule'
    end
  end

  root to: 'studios#index'
end
