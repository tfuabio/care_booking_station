Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'homes#top'
  get '/sign_in' => 'homes#sign_in', as: 'sign_in'

  # ケアマネ認証用
  devise_for :care_manager, controllers: {
    registrations: 'care_manager/registrations',
    sessions: 'care_manager/sessions'
  }

  # ケアマネゲストログイン用
  devise_scope :care_manager do
    post 'care_manager/guest_sign_in', to: 'care_manager/sessions#guest_sign_in'
  end

  # 施設認証用
  devise_for :facility, controllers: {
    registrations: 'facility/registrations',
    sessions: 'facility/sessions'
  }

  # 施設ゲストログイン用
  devise_scope :facility do
    post 'facility/guest_sign_in', to: 'facility/sessions#guest_sign_in'
  end

  # ケアマネユーザー情報用
  scope module: :care_manager do
    resource :care_managers, only: [:show, :edit, :update] do
      get 'unsubscribe'
      patch 'withdraw'
    end
  end

  # 施設ユーザー情報用
  scope module: :facility do
    resource :facilities, only: [:show, :edit, :update] do
      get 'unsubscribe'
      patch 'withdraw'
    end
  end

  # ケアマネージャー機能
  namespace :care_manager do
    resources :users, only: [:new, :create, :index, :show, :edit, :update]
    resources :use_plans, only: [:create, :index, :show, :edit, :update] do
      patch 'cancel' => 'use_plans#cancel', on: :member
      resources :booking_contacts, only: [:create] do
        patch 'determine'
      end
    end
  end

  # 施設機能
  namespace :facility do
    resources :users, only: [:index, :show] do
      patch 'contract_change' => 'users#contract_change', on: :member
    end
    resources :booking_contacts, only: [:index, :show] do
      patch 'reply' => 'booking_contacts#reply', on: :member
    end
    resources :schedules, only: [:index, :show, :create]
  end
end
