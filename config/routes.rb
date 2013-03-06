Plugindex::Application.routes.draw do

  mount Resque::Server, :at => "/resque"

  root :to => "home#index"

end
