Spsite::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  root :to => 'pages#welcome', :id => 'printely' #отправляет на действие welcome контроллера pages, с Id=printely
  match "sitemap" => "sitemap#index"
  match "myoffice" => "orders#index", :as => :myoffice

  resources :users do
      get 'admin', :on => :collection
      get 'forgot_password', :on => :collection
      post 'reset_password', :on => :collection
      get 'edit_profile', :on => :member
      get 'edit_password', :on => :member
      put 'update_profile', :on => :member
      put 'update_password', :on => :member
  end
  resources :rights
  resources :roles

  resources :documents
  match 'document/price_update' => 'documents#price_update'
  match 'document/get_paper_sizes' => 'documents#get_paper_sizes'
  match 'document/get_paper_types' => 'documents#get_paper_types'
  match 'document/get_print_margins' => 'documents#get_print_margins'
  match 'document/get_print_colors' => 'documents#get_print_colors'
  
  resources :scans
  match 'scan/ajaxupdate' => 'scans#ajaxupdate'
  match 'scan/create' => 'scans#create'

  resources :orders do
    resources :documents
    resources :scans
     get 'my', :on => :collection
     get 'admin', :on => :collection
     get 'cover', :on => :member
     get 'new_print', :on => :collection
     get 'new_scan', :on => :collection
     get 'get_materials', :on => :member
     get 'edit_files', :on => :member
     get 'edit_delivery', :on => :member
     get 'edit_status', :on => :member
  end
  
  match 'order/ajaxupdate' => 'orders#ajaxupdate'


  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    get 'logout' => :destroy
  end

  resources :pages do
    get 'admin', :on => :collection
    get 'no_page', :on => :collection
  end

  resources :pricelist_fotoprints do
    get 'admin', :on => :collection
  end

  resources :pricelist_deliveries do
    get 'admin', :on => :collection
  end
  
  resources :pricelist_scans do
    get 'admin', :on => :collection
  end

  resources :sections do
    resources :pages
    get 'admin', :on => :collection
  end

  resources :categories do
    resources :articles
    get 'admin', :on => :collection
  end

  resources :articles do
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
  
  resources :mailings do
    get 'admin', :on => :collection
  end

  namespace :lists do
    resources :order_statuses
    resources :paper_grades
    resources :paper_types
    resources :paper_sizes
    resources :paper_specifications do
      get 'admin', :on => :collection
    end
    resources :document_specifications do
      get 'admin', :on => :collection
    end
    resources :print_margins
    resources :print_colors
    resources :pre_print_operations
    resources :bindings
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
