Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'homes#top'
  get '/about' => 'homes#about', as: 'about'

  # ケアマネ認証用
  devise_for :care_manager, controllers: {
    registrations: 'care_manager/registrations',
    sessions: 'care_manager/sessions'
  }
  devise_scope :care_manager do
    post 'care_manager/guest_sign_in', to: 'care_manager/sessions#guest_sign_in'
  end

  # 施設認証用
  devise_for :facilities, controllers: {
    registrations: 'facilities/registrations',
    sessions: 'facilities/sessions'
  }

  # ケアマネ機能用
  scope module: :care_manager do
    resource :care_managers, only: [:show, :edit, :update] do
      get 'unsubscribe'
      patch 'withdraw'
    end
  end

  namespace :care_manager do
    resources :users, only: [:new, :create, :index, :show, :edit, :update]
    resources :use_plans, only: [:new, :create, :index, :show, :edit, :update] do
      resources :booking_contacts, only: [:new, :create, :index, :show, :edit, :update]
    end
  end
end
