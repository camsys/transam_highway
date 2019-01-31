Rails.application.routes.draw do
  resources :processable_uploads, only: [:index, :create, :destroy] do
    member do
      get 'process_file'
    end
  end
  
  # JSON API #
  namespace :api do
    namespace :v1 do
      get 'associations' => 'associations#index'

      resources :bridges
      resources :highway_structures
    end
  end

  resources :highway_maps, :only => [] do
    collection do
      get 'map'
      get 'table'
    end
  end
end
