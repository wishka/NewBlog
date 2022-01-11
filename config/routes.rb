Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'customers/new'
  root 'blog_pages#home'
  get 'help'    =>  'blog_pages#help'
  get 'about'   =>  'blog_pages#about'
  get 'contact' =>  'blog_pages#contact'
  get 'signup'  =>  'customers#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  resources :customers
  resources :blacklist_customers
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
end
