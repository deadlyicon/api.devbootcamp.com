require 'spec_helper'

describe '/v1/users' do

  describe 'GET /v1/users' do
    it "should" do
      get '/v1/users'
      expect( response.json ).to eq JSON.parse(dbc.users.all.to_json)
    end
  end

  describe 'POST /v1/users' do
    it "should create a user" do
      user = build('dbc/user', admin: true, student: true)
      attributes = {
        "name"                  => user.name,
        "email"                 => user.email,
        "password"              => user.password,
        "password_confirmation" => user.password_confirmation,
        "roles"                 => user.roles,
        "github_token"          => user.github_token,
      }
      post '/v1/users', user: attributes
      expect( response.json.keys.to_set     ).to eq %w{id name email roles github_token created_at updated_at}.to_set
      expect( response.json["id"]           ).to be_present
      expect( response.json["name"]         ).to eq attributes['name']
      expect( response.json["email"]        ).to eq attributes['email']
      expect( response.json["roles"]        ).to eq attributes['roles']
      expect( response.json["github_token"] ).to eq attributes['github_token']
      expect( response.json["created_at"]   ).to be_present
      expect( response.json["updated_at"]   ).to be_present
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
