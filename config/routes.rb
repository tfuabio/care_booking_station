Rails.application.routes.draw do
  root 'homes#top'
  get '/about' => 'homes#about', as: 'about'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # ケアマネ認証用
  devise_for :care_manager, controllers: {
    registrations: 'care_manager/registrations',
    sessions: 'care_manager/sessions'
  }

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
end
