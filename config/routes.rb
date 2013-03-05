Spsite::Application.routes.draw do
  
  mount Ckeditor::Engine => '/ckeditor'

  root :to => 'pages#welcome', :id => 'welcome' #отправляет на действие welcome контроллера pages, с Id=welcome
  match "sitemap" => "sitemap#index"
  match "myoffice" => "orders#index", :as => :myoffice

  resources :users
  resources :rights
  resources :roles

  resources :orders do
    resources :documents
     get 'my', :on => :collection
     get 'admin', :on => :collection
     get 'remove', :on => :collection
     get 'new_uploader', :on => :collection
  end

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    get 'logout' => :destroy
  end

  resources :pages do
    get 'admin', :on => :collection
    get 'no_page', :on => :collection
  end

  resources :sections do
    resources :pages
    get 'admin', :on => :collection
  end

  resources :articles do
    get 'admin', :on => :collection
  end

  resources :categories do
    resources :articles
    get 'admin', :on => :collection
  end

  resources :subservices do
    get 'admin', :on => :collection
  end

  resources :services do
    resources :subservices
    get 'admin', :on => :collection
  end

  resources :letters do
    get 'admin', :on => :collection
    get 'sent', :on => :collection
  end


  Ckeditor::Engine.routes.draw do
    resources :pictures, :only => [:index, :create, :destroy]
    resources :attachment_files, :only => [:index, :create, :destroy]
  end
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
