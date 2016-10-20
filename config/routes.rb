Printely::Application.routes.draw do

  root :to => 'pages#welcome', :id => 'printely' #отправляет на действие welcome контроллера pages, с Id=printely

  devise_for :users
  devise_scope :user do
    get 'login' => "devise/sessions#new"
    post 'login' => "devise/sessions#create"
    get 'logout' => "devise/sessions#destroy"
  end
  
  mount Ckeditor::Engine => '/ckeditor'

  
  get "sitemap" => "sitemap#index"
  get "myoffice" => "orders#index", :as => :myoffice

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
  get 'canvas_setting/show' => 'canvas_settings#show'

  resources :documents do
    resources :embedded_images
  end
  put 'document/update' => 'documents#update'
  get 'document/get_paper_sizes' => 'documents#get_paper_sizes'
  get 'document/get_paper_types' => 'documents#get_paper_types'
  get 'document/get_print_margins' => 'documents#get_print_margins'
  get 'document/get_print_colors' => 'documents#get_print_colors'
  
  resources :orders do
    resources :documents
    get 'my', :on => :collection
  end
  put '/order/set_documents_price' => 'orders#set_documents_price'
  put '/order/set_delivery_price' => 'orders#set_delivery_price'

  resources :order_steps


  resources :articles do
    get 'item_news', :on => :collection
  end
  get 'news/:id' => 'articles#show', :as => :news, 
                                        defaults: { item: 'news' }

  resources :categories do
    resources :articles
  end

  resources :services do
    resources :subservices
  end

  resources :letters do
    get 'sent', :on => :collection
  end
  
  get 'product_background/load_image' => 'product_backgrounds#load_image'

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


  get ':id', to: 'sections#show', as: :section

  # setup pages#index to give clean URLS
  get ':section_id/:subsection_id', :as => :section_subsection_pages,
                                     :via => :get,
                                     :controller => :pages, 
                                     :action => :show

                
  # setup pages#show to give clean URLS
  get ':section_id/:subsection_id/:id', :as => :section_subsection_page,
                                         :via => :get,
                                         :controller => :pages, 
                                         :action => :show
  


  TheRoleManagementPanel::Routes.mixin(self) #панель управления доступом TheRole

end
