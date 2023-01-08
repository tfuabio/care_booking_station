Rails.application.routes.draw do
  devise_for :care_managers
  devise_for :facilities
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
