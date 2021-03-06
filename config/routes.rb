Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home#home'

  # ====================================================================================================================
  # Members
  # ====================================================================================================================
  get 'members' => 'members#index'
  post 'members/new' => 'members#new'
  get 'members/new' => 'members#new'
  post 'members/edit/:id' => 'members#edit'
  get 'members/edit/:id' => 'members#edit'
  get 'members/delete/:id' => 'members#delete'

  get 'matches' => 'matches#index'
  post 'matches/new' => 'matches#new'
  get 'matches/new' => 'matches#new'
  get 'matches/delete/:id' => 'matches#delete'
end
