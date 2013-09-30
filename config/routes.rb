ApiDevbootcampCom::Application.routes.draw do

  namespace :v1, defaults: {format: :json}, except: [:new, :edit] do

    get :me, controller: 'me', action: 'show', as: 'me'

    resources :users do
      resources :challenge_attempts
    end

    resources :cohorts

    resources :challenges

    resources :challenge_attempts

  end

  not_found = ->(*){ [404, {"Content-Type" => "application/json; charset=utf-8"}, ['{"status":404,"error":"Not Found"}']] }
  match '*path' => not_found, via: :all
  root :to => not_found

end
