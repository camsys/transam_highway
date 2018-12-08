Rails.application.routes.draw do
  # JSON API #
  namespace :api do
    namespace :v1 do
      get 'associations' => 'associations#index'
    end
  end
end
