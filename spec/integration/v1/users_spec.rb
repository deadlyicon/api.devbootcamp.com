require 'spec_helper'

describe 'v1 users' do

  # let(:default_parameters){ {} }
  # let(:default_headers_or_env){ {} }
  # let(:default_headers){ default_headers_or_env }
  # let(:default_env){ default_headers_or_env }

  # %w{get post patch put delete head}.each do |method|
  #   define_method method do |path, parameters = {}, headers_or_env = {}|
  #     parameters = default_parameters.merge(parameters)
  #     headers_or_env = default_headers_or_env.merge(headers_or_env)
  #     super(path, parameters, headers_or_env)

  #     json = JSON.parse(response.body) rescue nil

  #     if response.status >= 500
  #       warn "RESPONSE FAILED"
  #       warn "#{request.method} #{request.url} #{request.params.inspect}"
  #       warn "status: #{response.status}"

  #       warn "errors: #{json["errors"].inspect}" if json
  #       warn "exception class: #{json["class"]}" if json
  #       warn "backtrace:\n#{json["backtrace"].join("\n")}" if json
  #       raise StandardError, "request failed", caller
  #     end
  #     JSON.parse(response.body)
  #   end
  # end


  let(:user_group){ Dbc::UserGroup.for users }
  let(:access_token){ user_group.access_token }

  before{
    default_parameters[:access_token] = access_token
  }

  context "as two students" do

    let(:users){ Dbc::User.student.first(2) }

    it "CRUD" do

      get '/v1/me'
      expect(response).to be_ok
      me = response.json

      expect( me["id"]                       ).to eq user_group.id
      expect( me["roles"]                    ).to eq user_group.roles

      expect( me["users"].length             ).to eq 2

      expect( me["users"][0]["id"]           ).to eq users[0].id.as_json
      expect( me["users"][0]["name"]         ).to eq users[0].name.as_json
      expect( me["users"][0]["email"]        ).to eq users[0].email.as_json
      expect( me["users"][0]["roles"]        ).to eq users[0].roles.as_json
      expect( me["users"][0]["github_token"] ).to eq users[0].github_token.as_json
      expect( me["users"][0]["created_at"]   ).to eq users[0].created_at.as_json
      expect( me["users"][0]["updated_at"]   ).to eq users[0].updated_at.as_json

      expect( me["users"][1]["id"]           ).to eq users[1].id.as_json
      expect( me["users"][1]["name"]         ).to eq users[1].name.as_json
      expect( me["users"][1]["email"]        ).to eq users[1].email.as_json
      expect( me["users"][1]["roles"]        ).to eq users[1].roles.as_json
      expect( me["users"][1]["github_token"] ).to eq users[1].github_token.as_json
      expect( me["users"][1]["created_at"]   ).to eq users[1].created_at.as_json
      expect( me["users"][1]["updated_at"]   ).to eq users[1].updated_at.as_json


      post '/v1/users', {
        user: {
          name:                  "Peter Miller",
          email:                 "peter.miller@gmail.com",
          password:              "ilovecats",
          password_confirmation: "ilovecats",
          roles:                 ["student"],
        }
      }
      expect(response.status).to eq 401
      expect(response.json["errors"]).to eq ["Unauthorized"]


      patch "/v1/users/1"
      expect(response).to be_a_bad_request
      expect(response.json["errors"]).to eq ["param not found: user"]

      patch "/v1/users/1", user: {name: "steve"}
      expect(response.status).to eq 401
      expect(response.json["errors"]).to eq ["Unauthorized"]


      patch "/v1/users/#{me["users"][0]["id"]}", {
        user: {
          password:              "poop",
          password_confirmation: "pooop",
        }
      }
      expect(response).to be_a_bad_request
      expect(response.json["errors"]).to eq ["Password confirmation doesn't match Password"]
    end
  end

  context "as an admin" do

    let(:users){ Dbc::User.admin.first(1) }

    it "should" do

      get '/v1/me'
      expect(response).to be_ok
      me = response.json

      expect( me["id"]                       ).to eq user_group.id
      expect( me["roles"]                    ).to eq user_group.roles

      expect( me["users"].length             ).to eq 1

      expect( me["users"][0]["id"]           ).to eq users[0].id.as_json
      expect( me["users"][0]["name"]         ).to eq users[0].name.as_json
      expect( me["users"][0]["email"]        ).to eq users[0].email.as_json
      expect( me["users"][0]["roles"]        ).to eq users[0].roles.as_json
      expect( me["users"][0]["github_token"] ).to eq users[0].github_token.as_json
      expect( me["users"][0]["created_at"]   ).to eq users[0].created_at.as_json
      expect( me["users"][0]["updated_at"]   ).to eq users[0].updated_at.as_json

      post '/v1/users', {
        user: {
          name:                  "Peter Miller",
          email:                 "peter.miller@gmail.com",
          password:              "ilovecats",
          password_confirmation: "ilovecats",
          roles:                 ["student"],
        }
      }
      expect(response).to be_ok
      peter = response.json

      get "/v1/users/#{peter["id"]}"
      expect(response).to be_ok
      expect(response.json).to eq peter


      put "/v1/users/#{peter["id"]}", {
        user: { email: "pete.miller@yahoo.com", }
      }
      expect(response).to be_ok
      new_peter = response.json

      expect( new_peter ).to eq peter.update(new_peter.slice("email", "updated_at"))

      get "/v1/users/#{peter["id"]}"
      expect(response).to be_ok
      expect(response.json).to eq new_peter


      patch "/v1/users/#{peter["id"]}", {
        user: {
          password:              "poop",
          password_confirmation: "pooop",
        }
      }
      expect(response).to be_a_bad_request
      expect(response.json["errors"]).to eq ["Password confirmation doesn't match Password"]
    end

  end
end
