ActionController::Routing::Routes.draw do |map|
  map.connect '/equipment/', :controller => 'item_categories'
  
  map.resources :item_categories, :as => 'categories', :path_prefix => '/equipment',
    :collection => {
      :auto_complete_for_item_name => :get,
      :search => :get
    }, :member => {
      :move_up => :put,
      :move_down => :put
    } do |item_categories|
    item_categories.resources :items do |items|
      items.resources :item_notes, :as => 'notes'
      items.resources :item_quantity_changes, :as => 'quantity_changes'
    end
  end
  
  
  map.resources :rental_action_searches, :as => 'search', :path_prefix => 'rental_actions',
    :collection => {
      :auto_complete_for_rental_action_name => :get,
      :choose_customer => :get
    }
    
  map.resources :rental_actions,
    :collection => {
      :choose_template => :get
    },
    :member => {
      :deactivate => :put,
      :activate => :put,
      :choose_customer => :get,
      :set_customer => :put
    } do |rental_actions|
    rental_actions.resources :item_rentals,
      :collection => {
        :choose_item => :get,
        :all_handed_out => :put,
        :all_returned => :put
      }, :member => {
        :handed_out => :put,
        :returned => :put,
        :reset_state => :put
      }
    rental_actions.resources :bills,
      :collection => {
        :new_step_2 => :post,
        :generate_serial_number => :get
      }
  end
  
  
  map.resources :skills, :path_prefix => '/employees',
    :collection => {
      :generate_skill_field => :get,
      :auto_complete_for_skill_name => :get
    }
    
  map.resources :employee_searches, :as => 'search', :path_prefix => '/employees',
    :collection => {
      :auto_complete_for_contact_name => :get
    }
    
  map.resources :employees,
    :collection => {
      :choose_contact_template => :get
    }, :member => {
      :detach_contact => :put
    }
  
  
  map.resources :customer_searches, :as => 'search', :path_prefix => '/customers',
    :collection => {
      :auto_complete_for_contact_name => :get
    }
    
  map.resources :customers,
    :collection => {
      :choose_contact_template => :get
    }, :member => {
      :detach_contact => :put
    }
  
  
  map.resources :users
  map.resource :session
  
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.signup '/signup', :controller => 'users', :action => 'new'
  
  
  map.resources :phone_number_types, :path_prefix => '/settings'
  
  map.cancel_choosing '/cancel_choosing', :controller => 'choosing_helper', :action => 'cancel_choosing'


  map.root :controller => 'home'
  map.about '/about', :controller => 'home', :action => 'about'
end
