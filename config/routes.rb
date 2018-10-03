Rails.application.routes.draw do
  resources :expenses do
      collection { get :show_many };
      collection { get :add_new }
    end
  resources :dailystats
  resources :dailybanks do
    member do
       post 'submit_comment';
       post 'mgmt_lock';
       post 'lock_float';
       post 'lock_event';
       post 'create_new_expense_record';
       post 'put_to_mgmt_review';
       post 'no_expenses_to_add';
       post 'mgmt_recalculate'; 
       get 'mgmt_review';
    end
     resources :expenses
  end
 
  resources :exemptions
  resources :functions
  resources :cashfloats do
      collection { post :validate };
      collection { get :show_float }
    end

  get 'daily_checks/today'
  get 'daily_checks/yesterday'
  get 'daily_checks/history'

  get 'messages/new'
  post 'messages/create'   => 'messages#create'
  post 'customers/subscribe'   => 'customers#subscribe'

  resources :errors
  resources :users
  resources :customers
  resources :bookings do
      collection { post :booking_confirmation };
      collection { post :booking_cancellation };
      collection { post :booking_get_times };
      collection { post :booking_advanced };
      collection { post :mgmt_edit };
    end  
  resources :tables do
      collection { post :booking_enquiry }
    end  
  resources :rdetails
  resources :restaurants
  resources :accounts
  resources :enquiries
  resources :categories
  resources :products do
    		 collection { post :import }
       end
   resources :sessions, only: [:new, :create, :destroy]
  
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'static_pages#hfsk_home'
 
 # get '/show_many/:id' => 'expenses#show_many'
  get '/index_full' => 'dailybanks#index_full'
  get '/index_ongoing' => 'dailybanks#index_ongoing'
  get '/latest' => 'dailybanks#latest'
  get '/history' => 'dailybanks#history'
  get '/history_week' => 'dailybanks#history_week'
  get '/history_month' => 'dailybanks#history_month'
 # get '/mgmt_review/:id' => 'dailybanks#mgmt_review'
  get '/tax_quarter' => 'dailybanks#tax_quarter'
  get '/home' => 'static_pages#home'
  get '/help' => 'static_pages#help'
#  get '/day_picker' => 'static_pages#day_picker'
  get '/booking_enquiry' => 'static_pages#booking_enquiry'
  get '/new_booking_enquiry' => 'static_pages#new_booking_enquiry'
  get '/booking_advanced' => 'static_pages#booking_advanced'
  get '/function_room_enquiry' => 'static_pages#function_room_enquiry'
  get '/download_menu_pdf' => 'static_pages#download_menu_pdf'
#  get '/download_lunch_pdf' => 'static_pages#download_lunch_pdf'
#  get '/download_evening_pdf' => 'static_pages#download_evening_pdf'
  get '/download_function_pdf' => 'static_pages#download_function_pdf'
  get '/download_engine_tandc_pdf' => 'static_pages#download_engine_tandc_pdf'
  get '/download_festive_pdf' => 'static_pages#download_festive_pdf'
  get '/basic_report' => 'bookings#basic_report'
  get '/deposit_report' => 'bookings#deposit_report'
  get '/confirmation_report' => 'bookings#confirmation_report'
  get '/confirmation_report_month' => 'bookings#confirmation_report_month'
  get '/calendar' => 'bookings#calendar'
  get '/availability' => 'bookings#availability'
  get '/availability_detail' => 'bookings#availability_detail'
  get '/all_customers' => 'customers#all_customers'
  get '/all_bookings' => 'bookings#all_bookings'
  get '/download_bookings_pdf' => "bookings#download_bookings_pdf"
  get '/download_bookings_evening_pdf' => "bookings#download_bookings_evening_pdf"
  get '/mgmt_edit_booking' => 'bookings#mgmt_edit'
  get '/search_bookings' => 'bookings#search_bookings' 
  get '/cashfloats_validate' => 'cashfloats#validate'  
  get '/download_end_of_night_pdf' => "dailybanks#download_end_of_night_pdf" 
  get '/download_dailybank_tax_accounting_pdf' => "dailybanks#download_dailybank_tax_accounting_pdf"
  get '/download_expenses_report_pdf' => "expenses#download_expenses_report_pdf" 
  
  get '/hfsk_home' => 'static_pages#hfsk_home'
  get '/hfsk_about' => 'static_pages#hfsk_about'
  get '/hfsk_blog' => 'static_pages#hfsk_blog'
  get '/hfsk_booking' => 'static_pages#booking_enquiry'
  get '/hfsk_location' => 'static_pages#hfsk_location'
  get '/hfsk_pay_deposit' => 'static_pages#hfsk_pay_deposit'
  get '/hfsk_confirm_deposit' => 'static_pages#hfsk_confirm_deposit'
  get '/hfsk_get_in_touch' => 'static_pages#hfsk_get_in_touch'
  get '/hfsk_careers' => 'static_pages#hfsk_careers'
  get '/hfsk_menu' => 'static_pages#hfsk_menu'
  get '/hfsk_holiday_season' => 'static_pages#hfsk_holiday_season'
  
  #new pages
  get '/hfsk_home_new' => 'static_pages#hfsk_home_new'
  get '/new_booking_enquiry_new' => 'static_pages#new_booking_enquiry_new'
  get '/hfsk_location_new' => 'static_pages#hfsk_location_new'
  get '/hfsk_menu_new' => 'static_pages#hfsk_menu_new'
  get '/hfsk_what_we_do' => 'static_pages#hfsk_what_we_do'
  get '/hfsk_get_in_touch_new' => 'static_pages#hfsk_get_in_touch_new'
 
  get "static_pages/home"
  get "static_pages/help"
  get "static_pages/day_picker"
  get "static_pages/booking_enquiry"
  get "static_pages/new_booking_enquiry"
  get "static_pages/booking_advanced"
  get "static_pages/function_room_enquiry"
  get "static_pages/booking_confirm"  
  
  get "static_pages/hfsk_home"
  get "static_pages/hfsk_blog"
  get "static_pages/hfsk_about"
  get "static_pages/hfsk_location"
  get "static_pages/hfsk_pay_deposit"
  get "static_pages/hfsk_confirm_deposit"
  get "static_pages/hfsk_get_in_touch"
  get "static_pages/hfsk_careers"
  get "static_pages/hfsk_menu"
  get "static_pages/hfsk_holiday_season"
  get "sessions/new"
  get "static_pages/new_booking_enquiry_new"
  
  resources :charges
  
 # mount StripeEvent::Engine => '/stripe-events'
  
  get  '/pay_deposit/:id', to: 'charges#new',      as: :show_pay
  post '/pay_deposit/:id', to: 'charges#create',   as: :pay_deposit
#  get '/paid/:id', to: 'orders#show',   as: :paid  
#  get  '/show/:id', to: 'orders#show',      as: :show_order
#  get  '/edit/:id', to: 'orders#edit',      as: :edit_new_order

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
