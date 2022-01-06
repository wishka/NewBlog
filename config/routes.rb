Rails.application.routes.draw do
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
end
