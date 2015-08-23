Printely::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  root :to => 'pages#welcome', :id => 'printely' #отправляет на действие welcome контроллера pages, с Id=printely
  match "sitemap" => "sitemap#index"
  match "myoffice" => "orders#index", :as => :myoffice

  resources :users do
      get 'forgot_password', :on => :collection
      post 'reset_password', :on => :collection
      get 'edit_profile', :on => :member
      get 'edit_password', :on => :member
      put 'update_profile', :on => :member
      put 'update_password', :on => :member
      get 'check_email', :on => :collection
      get 'check_phone', :on => :collection
      get 'check_pass', :on => :collection
  end

  resources :embedded_images
  match 'canvas_setting/show' => 'canvas_settings#show'

  resources :documents do
    resources :embedded_images
  end
  match 'document/update' => 'documents#update'
  match 'document/get_paper_sizes' => 'documents#get_paper_sizes'
  match 'document/get_paper_types' => 'documents#get_paper_types'
  match 'document/get_print_margins' => 'documents#get_print_margins'
  match 'document/get_print_colors' => 'documents#get_print_colors'
  
  resources :orders do
    resources :documents
    get 'my', :on => :collection
  end
  match '/order/set_documents_price' => 'orders#set_documents_price'
  match '/order/set_delivery_price' => 'orders#set_delivery_price'


  resources :order_steps

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    get 'logout' => :destroy
  end

  resources :articles do
    get 'item_news', :on => :collection
  end
  match 'news/:id' => 'articles#show', :as => :news, 
                                        defaults: { item: 'news' }

  resources :categories do
    resources :articles
  end

  resources :services do
    resources :subservices
  end
  
  resources :pages do
    get 'no_page', :on => :collection
  end

  resources :letters do
    get 'sent', :on => :collection
  end
  
  match 'product_background/load_image' => 'product_backgrounds#load_image'
  
  namespace :admin do
    resources :settings
    resources :articles
    resources :categories
    resources :documents do
      get 'download_pdf', :on => :member
    end
    resources :letters
    resources :mailings 
    resources :orders do
      resources :documents
      get 'cover', :on => :member
      get 'get_materials', :on => :member
      get 'edit_documents', :on => :member
      get 'edit_delivery', :on => :member
      get 'edit_status', :on => :member
      put 'update_documents', :on => :member
      put 'update_delivery', :on => :member
      put 'update_status', :on => :member
    end
    resources :pages
    resources :rights
    resources :roles
    resources :sections
    resources :subsections
    resources :services
    resources :subservices
    resources :users
    namespace :lists do
      resources :bindings
      resources :order_statuses
      resources :order_types
      resources :paper_grades
      resources :paper_densities
      resources :canvas_settings
      resources :paper_types
      resources :paper_sizes
      resources :paper_specifications
      resources :print_margins
      resources :product_backgrounds
      resources :delivery_towns
      resources :delivery_zones
      resources :pre_print_operations
      resources :print_colors
      resources :scan_specifications
    end
  end

  # setup pages#show to give clean URLS
  match ':section_id', :as => :section_page,
                           :via => :get,
                           :controller => :pages, 
                           :action => :show
                           
  # setup pages#index to give clean URLS
  match ':section_id/:subsection_id', :as => :section_subsection_pages,
                                     :via => :get,
                                     :controller => :pages, 
                                     :action => :index

                
  # setup pages#show to give clean URLS
  match ':section_id/:subsection_id/:id', :as => :section_subsection_page,
                                         :via => :get,
                                         :controller => :pages, 
                                         :action => :show
  


  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'errors#error_404'
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
