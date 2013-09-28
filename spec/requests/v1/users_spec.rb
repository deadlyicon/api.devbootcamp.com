require 'spec_helper'

describe '/v1/users' do

  describe 'GET /v1/users' do
    it "should" do
      get '/v1/users'
      expect( response.json ).to eq []
    end
  end

  describe 'POST /v1/users' do
    it "should create a user" do
      attributes = attributes_for(:user)
      post '/v1/users', user: attributes
      expect( response.json ).to eq attributes
    end
  end

end


#     v1_users GET    /v1/users(.:format)                                      v1/users#index
#              POST   /v1/users(.:format)                                      v1/users#create
#  new_v1_user GET    /v1/users/new(.:format)                                  v1/users#new
# edit_v1_user GET    /v1/users/:id/edit(.:format)                             v1/users#edit
#      v1_user GET    /v1/users/:id(.:format)                                  v1/users#show
#              PATCH  /v1/users/:id(.:format)                                  v1/users#update
#              PUT    /v1/users/:id(.:format)                                  v1/users#update
#              DELETE /v1/users/:id(.:format)                                  v1/users#destroy
