Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :sms, :only => [:create]
  resources :cameras, :only => [:show]
  resources :pictures, :only => [:index, :update]
end
