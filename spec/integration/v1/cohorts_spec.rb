require 'spec_helper'

describe 'v1 cohorts' do

  describe "creating a cohort" do
    let(:access_token){ Dbc::UserGroup.for(Dbc::User.admin.first!).access_token }
    before{
      default_parameters[:access_token] = access_token
    }
    it "should work" do

      params = {
        "name"       => "purple nerpals",
        "location"   => "San Francisco",
        "start_date" => 2.weeks.from_now,
      }

      post '/v1/cohorts', {"cohort" => params}
      expect(response).to be_ok
      cohort = response.json

      expect( cohort["name"]       ).to eq "purple nerpals"
      expect( cohort["slug"]       ).to eq "purple_nerpals"
      expect( cohort["email"]      ).to eq "purple.nerpals-2013@devbootcamp.com"
      expect( cohort["location"]   ).to eq "San Francisco"
      expect( cohort["start_date"] ).to eq params["start_date"].to_date.as_json
      expect( cohort["visible"]    ).to eq true

      users = 5.times.map do |i|
        params = {
          "name"                  => "new usser #{i}",
          "email"                 => "new.user.#{1}@gmail.com",
          "password"              => "ilovecats",
          "password_confirmation" => "ilovecats",
          "roles"                 => ["student"],
          "cohort_id"             => cohort["id"],
        }

        post '/v1/users', {"user" => params}
        expect(response).to be_ok
        response.json
      end

      # get "/v1/cohorts/#{cohort["id"]}"

    end
  end

end
