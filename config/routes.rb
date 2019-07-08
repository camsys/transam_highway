Rails.application.routes.draw do

  resources :inspections do

    resources :elements do 
      collection do 
        post :save_quantity_changes
      end

      member do 
        get :edit_comment
      end

      resources :child_elements
      resources :defects do 
        member do 
          get :edit_comment
        end

        resources :images
      end

      resources :images
    end

    resources :images

    collection do 
      get 'reset'
      post 'new_search'
    end
  end

  resources :streambed_profiles do
    resources :streambed_profile_points

    collection do
      put 'update_many'
    end
  end

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
      get 'bridge_conditions' => 'bridge_conditions#index'
      get 'elements' => 'elements#index'
      get 'defects' => 'defects#index'
      get 'defect_definitions' => 'defect_definitions#index'
      get 'element_definitions' => 'element_definitions#index'

      resources :inspections, only: [:index, :update]

      resources :bridges
      resources :culverts
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
