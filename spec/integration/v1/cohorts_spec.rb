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
      expect( cohort["start_date"] ).to eq params["start_date"].as_json
      expect( cohort["visible"]    ).to eq true

    end
  end

end
