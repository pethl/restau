Rails.application.routes.draw do
  resources :expenses do
      collection { get :show_many }
    end
      resources :dailystats
  resources :dailybanks do
      collection { post :submit_comment };
      collection { post :mgmt_lock };
      collection { post :lock_float };
      collection { post :lock_event };
      collection { post :create_new_expense_record };
      collection { post :no_expenses_to_add}; 
       collection { get :mgmt_review};
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
      collection { post :mgmt_edit }
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
  get '/download_lunch_pdf' => 'static_pages#download_lunch_pdf'
  get '/download_evening_pdf' => 'static_pages#download_evening_pdf'
  get '/download_function_pdf' => 'static_pages#download_function_pdf'
  get '/download_engine_tandc_pdf' => 'static_pages#download_engine_tandc_pdf'
  get '/download_festive_pdf' => 'static_pages#download_festive_pdf'
  get '/basic_report' => 'bookings#basic_report'
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
  
  get '/hfsk_home' => 'static_pages#hfsk_home'
  get '/hfsk_about' => 'static_pages#hfsk_about'
  get '/hfsk_blog' => 'static_pages#hfsk_blog'
  get '/hfsk_booking' => 'static_pages#booking_enquiry'
  get '/hfsk_location' => 'static_pages#hfsk_location'
  get '/hfsk_get_in_touch' => 'static_pages#hfsk_get_in_touch'
  get '/hfsk_careers' => 'static_pages#hfsk_careers'
  get '/hfsk_menu' => 'static_pages#hfsk_menu'
  get '/hfsk_holiday_season' => 'static_pages#hfsk_holiday_season'
  
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
  get "static_pages/hfsk_get_in_touch"
  get "static_pages/hfsk_careers"
  get "static_pages/hfsk_menu"
  get "static_pages/hfsk_holiday_season"
  get "sessions/new"

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
