Rails.application.routes.draw do
  #devise_for :care_managers
  #devise_for :facilities
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # ケアマネ認証用
  devise_for :care_managers, controllers: {
    registrations: "care_managers/registrations",
    sessions: 'care_managers/sessions'
  }

  # 施設認証用
  devise_for :facilities, controllers: {
    registrations: "facilities/registrations",
    sessions: "facilities/sessions"
  }
end
