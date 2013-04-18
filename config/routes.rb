PostPro::Application.routes.draw do

  resources :announcements

  get 'queue/index'
  match 'queue' => 'queue#index'
  match 'queue/numcallins' => 'queue#get_num_callins'
  match 'queue/numquestions' => 'queue#get_num_questions'
  match 'queue/dequeue' => 'queue#dequeue_callin'
  match 'queue/correct' => 'queue#correct'
  match 'queue/incorrect' => 'queue#incorrect'
  match 'queue/requeue' => 'queue#requeue'

  match 'queue/delegate' => 'queue#delegate'

  match 'qqueue' => 'queue#qindex'
  match 'qqueue/dequeue' => 'queue#dequeue_question'
  match 'qqueue/answered' => 'queue#answered_question'
  match 'qqueue/attention' => 'queue#attention_question'

  resources :teams do
    collection do
      get 'genpassword'
    end
  end

  resources :puzzles do
    member do
      get 'callin'
      post 'post_callin'
    end
  end

  match 'god' => 'puzzles#god'
  match 'upload' => 'puzzles#upload', :via => :get
  match 'upload' => 'puzzles#upload_post', :via => :post
  match 'upload/delete' => 'puzzles#resource_delete'

  match 'ask_question' => 'puzzles#ask_question', :via => :get
  match 'ask_question' => 'puzzles#submit_question', :via => :post

  match 'login' => 'login#login', :via => :post
  match 'logout' => 'login#logout'
  root :to => 'login#index'

  # get "login/index"

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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
