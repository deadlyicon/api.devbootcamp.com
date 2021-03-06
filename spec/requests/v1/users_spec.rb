require 'spec_helper'

describe '/v1/users' do

  let(:user){ Dbc::User.student.last! }

  let(:current_user){ Dbc::User.admin.first! }

  before do
    become current_user
  end

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
        "name"                  => user.name.as_json,
        "email"                 => user.email.as_json,
        "password"              => user.password.as_json,
        "password_confirmation" => user.password_confirmation.as_json,
        "roles"                 => user.roles.as_json,
        "github_token"          => user.github_token.as_json,
      }

      expect{
        post '/v1/users', user: attributes
        expect(response).to be_success
      }.to change{ Dbc::User.count }.by(1)

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

  describe "GET /v1/users/:id" do
    it "should return that user as json" do
      get "v1/users/#{user.id}"

      expect(response.json).to eq(
        "id"           => user.id,
        "name"         => user.name.as_json,
        "email"        => user.email.as_json,
        "roles"        => user.roles.as_json,
        "github_token" => user.github_token.as_json,
        "created_at"   => user.created_at.as_json,
        "updated_at"   => user.updated_at.as_json,
      )
    end
  end

  describe "PUT /v1/users/:id" do
    it "should update and then return that user as json" do

      updates = {
        "name"                  => "Steven Pinker",
        "email"                 => "steven@pinker.net",
        "password"              => "3x@#32wDS#3",
        "password_confirmation" => "3x@#32wDS#3",
        "roles"                 => ["student", "admin"],
      }

      put "v1/users/#{user.id}", "user" => updates

      expect(response).to be_success

      user.reload

      expect(response.json).to eq(
        "id"           => user.id,
        "name"         => updates["name"].as_json,
        "email"        => updates["email"].as_json,
        "roles"        => updates["roles"].as_json,
        "github_token" => user.github_token.as_json,
        "created_at"   => user.created_at.as_json,
        "updated_at"   => user.updated_at.as_json,
      )

      expect( user.name         ).to eq updates["name"].as_json
      expect( user.email        ).to eq updates["email"].as_json
      expect( user.roles        ).to eq updates["roles"].as_json

      expect( user.authenticate(updates["password"]) ).to_not be_false
    end

    context "when the passwords do not match" do
      it "it should fail" do
        updates = {
          "password"              => "3x@#32wDS#3",
          "password_confirmation" => "455^$dsa@@33",
        }

        put "v1/users/#{user.id}", "user" => updates

        expect(response.status).to eq 400
        expect(response.json["errors"]).to eq ["Password confirmation doesn't match Password"]
      end
    end

    context "when you don't have perission to change the password" do

      let(:current_user){ Dbc::User.student.first! }

      it "it should fail" do
        updates = {
          "password"              => "ilovecheese",
          "password_confirmation" => "ilovecheese",
        }

        put "v1/users/#{user.id}", "user" => updates

        expect(response.status).to eq 401
      end

    end
  end


  describe "DELETE /v1/users/:id" do

    as_an :admin do
      it "should delete the user" do
        delete "/v1/users/#{user.id}"
        expect(response.status).to eq 200
        expect(response.json).to eq(
          "id"           => user.id,
          "name"         => user.name.as_json,
          "email"        => user.email.as_json,
          "roles"        => user.roles.as_json,
          "github_token" => user.github_token.as_json,
          "created_at"   => user.created_at.as_json,
          "updated_at"   => user.updated_at.as_json,
        )
        expect{ user.reload }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    as_a :student do
      it "should render unauthorized" do
        delete "/v1/users/#{user.id}"
        expect(response.status).to eq 401
        expect(response.json).to eq("errors"=>["Unauthorized"], "status"=>401)
      end
    end


    as_an :editor do
      it "should render unauthorized" do
        delete "/v1/users/#{user.id}"
        expect(response.status).to eq 401
        expect(response.json).to eq("errors"=>["Unauthorized"], "status"=>401)
      end
    end

  end

end
