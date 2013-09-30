require 'spec_helper'

describe 'v1 users' do

  let(:default_parameters){ {} }
  let(:default_headers_or_env){ {} }
  let(:default_headers){ default_headers_or_env }
  let(:default_env){ default_headers_or_env }

  %w{get post patch put delete head}.each do |method|
    define_method method do |path, parameters = {}, headers_or_env = {}|
      parameters = default_parameters.merge(parameters)
      headers_or_env = default_headers_or_env.merge(headers_or_env)
      super(path, parameters, headers_or_env)
      raise "request failed: #{response.status}: #{response.body}" if response.status >= 500
      JSON.parse(response.body)
    end
  end

  let(:users){ [Dbc::User.admin.first!] }
  let(:user_group){ Dbc::UserGroup.for users }
  let(:access_token){ user_group.access_token }

  before{ default_parameters[:access_token] = access_token }

  it "CRUD" do

    me = get '/v1/me'

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


    peter = post '/v1/users', {
      user: {
        name:                  "Peter Miller",
        email:                 "peter.miller@gmail.com",
        password:              "ilovecats",
        password_confirmation: "ilovecats",
        roles:                 ["student"],
      }
    }

    expect( get "/v1/users/#{peter["id"]}" ).to eq peter


    new_peter = put "/v1/users/#{peter["id"]}", {
      user: { email: "pete.miller@yahoo.com", }
    }

    expect( new_peter ).to eq peter.update(new_peter.slice("email", "updated_at"))

    expect( get "/v1/users/#{peter["id"]}" ).to eq new_peter


    errors = patch "/v1/users/#{peter["id"]}", {
      user: {
        password:              "poop",
        password_confirmation: "pooop",
      }
    }
    expect(response).to be_a_bad_request
    expect(errors["errors"]).to eq ["Password confirmation doesn't match Password"]


    # binding.pry


  end
end
