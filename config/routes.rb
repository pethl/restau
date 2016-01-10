Rails.application.routes.draw do
  resources :customers
  resources :bookings do
      collection { post :booking_confirmation };
      collection { post :booking_cancellation }
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
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'static_pages#home'
  
  get '/home' => 'static_pages#home'
   get '/help' => 'static_pages#help'
  get '/day_picker' => 'static_pages#day_picker'
  get '/booking_enquiry' => 'static_pages#booking_enquiry'
   get '/download_pdf' => 'static_pages#download_pdf'
  
  get '/hfsk_home' => 'static_pages#hfsk_home'
   get '/hfsk_about' => 'static_pages#hfsk_about'
   get '/hfsk_menu' => 'static_pages#hfsk_menu'
    get '/hfsk_booking' => 'static_pages#booking_enquiry'
  
  get "static_pages/home"
  get "static_pages/help"
  get "static_pages/day_picker"
  get "static_pages/booking_enquiry"
  get "static_pages/booking_confirm"  
  
  get "static_pages/hfsk_home"
  get "static_pages/hfsk_menu"
  get "static_pages/hfsk_about"

  

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
