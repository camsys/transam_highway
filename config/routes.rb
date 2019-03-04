Rails.application.routes.draw do

  resources :inspections

  resources :processable_uploads, only: [:index, :create, :destroy] do
    member do
      get 'process_file'
    end
  end
  
  # JSON API #
  namespace :api do
    namespace :v1 do
      get 'reference_data' => 'references#index'
      get 'associations' => 'associations#index'
      get 'defect_definitions' => 'defect_definitions#index'
      get 'element_definitions' => 'element_definitions#index'

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
