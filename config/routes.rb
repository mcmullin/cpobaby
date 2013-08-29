CPObaby::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  root              to: 'static_pages#home'
  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'

  devise_for :admins
  #mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :reps

  devise_scope :rep do
    get 'signup',     to: 'devise/registrations#new',                 as: :signup
    get 'signin',     to: 'devise/sessions#new',                      as: :signin
    match 'signout',  to: 'devise/sessions#destroy',  via: :delete,   as: :signout
  end

  get "reps/index"

  resources :products do
    collection do
      post :import
    end
  end

  resources :orders do
    get :autocomplete_rep_number, on: :collection
  end


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

#== Route Map
# Generated on 03 Aug 2013 18:54
#
#                    help        /help(.:format)               static_pages#help
#                   about        /about(.:format)              static_pages#about
#                 contact        /contact(.:format)            static_pages#contact
#       new_admin_session GET    /admins/sign_in(.:format)     devise/sessions#new
#           admin_session POST   /admins/sign_in(.:format)     devise/sessions#create
#   destroy_admin_session DELETE /admins/sign_out(.:format)    devise/sessions#destroy
#            admin_unlock POST   /admins/unlock(.:format)      devise/unlocks#create
#        new_admin_unlock GET    /admins/unlock/new(.:format)  devise/unlocks#new
#                         GET    /admins/unlock(.:format)      devise/unlocks#show
#         new_rep_session GET    /reps/sign_in(.:format)       devise/sessions#new
#             rep_session POST   /reps/sign_in(.:format)       devise/sessions#create
#     destroy_rep_session DELETE /reps/sign_out(.:format)      devise/sessions#destroy
#            rep_password POST   /reps/password(.:format)      devise/passwords#create
#        new_rep_password GET    /reps/password/new(.:format)  devise/passwords#new
#       edit_rep_password GET    /reps/password/edit(.:format) devise/passwords#edit
#                         PUT    /reps/password(.:format)      devise/passwords#update
# cancel_rep_registration GET    /reps/cancel(.:format)        devise/registrations#cancel
#        rep_registration POST   /reps(.:format)               devise/registrations#create
#    new_rep_registration GET    /reps/sign_up(.:format)       devise/registrations#new
#   edit_rep_registration GET    /reps/edit(.:format)          devise/registrations#edit
#                         PUT    /reps(.:format)               devise/registrations#update
#                         DELETE /reps(.:format)               devise/registrations#destroy
#                  signup GET    /signup(.:format)             devise/registrations#new
#                  signin GET    /signin(.:format)             devise/sessions#new
#                 signout DELETE /signout(.:format)            devise/sessions#destroy
#         import_products POST   /products/import(.:format)    products#import
#                products GET    /products(.:format)           products#index
#                         POST   /products(.:format)           products#create
#             new_product GET    /products/new(.:format)       products#new
#            edit_product GET    /products/:id/edit(.:format)  products#edit
#                 product GET    /products/:id(.:format)       products#show
#                         PUT    /products/:id(.:format)       products#update
#                         DELETE /products/:id(.:format)       products#destroy
#                  orders GET    /orders(.:format)             orders#index
#                         POST   /orders(.:format)             orders#create
#               new_order GET    /orders/new(.:format)         orders#new
#              edit_order GET    /orders/:id/edit(.:format)    orders#edit
#                   order GET    /orders/:id(.:format)         orders#show
#                         PUT    /orders/:id(.:format)         orders#update
#                         DELETE /orders/:id(.:format)         orders#destroy
