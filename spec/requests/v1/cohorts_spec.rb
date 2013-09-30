require 'spec_helper'

describe '/v1/cohorts' do


  let(:cohort){ Dbc::Cohort.first! }

  def serialize cohort
    {
      "id"          => cohort.id.as_json,
      "name"        => cohort.name.as_json,
      "location_id" => cohort.location_id.as_json,
      "in_session"  => cohort.in_session.as_json,
      "start_date"  => cohort.start_date.as_json,
      "email"       => cohort.email.as_json,
      "visible"     => cohort.visible.as_json,
      "slug"        => cohort.slug.as_json,
    }
  end

  as_an :admin do

    describe 'GET /v1/cohorts' do
      it "should render all cohorts as json" do
        get '/v1/cohorts'
        expect( response ).to be_ok
        expect( response.body ).to eq dbc.cohorts.all.to_json
      end
    end

    describe 'POST /v1/cohorts' do
      it "should create a cohort and render it as json" do
        attributes = attributes_for('dbc/cohort').slice(
          :name,
          :location_id,
          :in_session,
          :start_date,
          :email,
          :visible,
          :slug,
        ).as_json

        expect{
          post '/v1/cohorts', cohort: attributes
          expect( response ).to be_ok
        }.to change{ Dbc::Cohort.count }.by(1)

        expect( response.json.slice(*attributes.keys) ).to eq attributes
      end
    end


    describe "GET /v1/cohorts/:id" do
      it "should render the cohort as json" do
        get "v1/cohorts/#{cohort.id}"
        expect(response.json).to eq serialize(cohort)
      end
    end

    describe "PUT /v1/cohorts/:id" do
      it "should update a cohort and render it as json" do
        updates = {
          "name"  => "hump dragons",
          "email" => "hump.dragons-2014@devbootcamp.com",
        }

        put "v1/cohorts/#{cohort.id}", "cohort" => updates

        expect(response).to be_success
        cohort.reload
        expect(response.json).to eq serialize(cohort)
        expect( cohort.name  ).to eq updates["name"].as_json
        expect( cohort.email ).to eq updates["email"].as_json
      end
    end


    describe "DELETE /v1/users/:id" do
      it "should delete the cohort" do
        delete "/v1/cohorts/#{cohort.id}"
        expect(response.status).to eq 200
        expect(response.json).to eq serialize(cohort)
        expect{ cohort.reload }.to raise_error ActiveRecord::RecordNotFound
      end
    end

  end



  as_a :student do

    describe 'GET /v1/cohorts' do
      it "should render all cohorts as json" do
        get '/v1/cohorts'
        expect( response ).to be_ok
        expect( response.body ).to eq dbc.cohorts.all.to_json
      end
    end

    describe 'POST /v1/cohorts' do
      it "should render unauthorized" do
        post '/v1/cohorts', cohort: {name: "clown pajams"}
        expect(response.status).to eq 401
        expect(response.json).to eq("errors"=>["Unauthorized"], "status"=>401)
      end
    end


    describe "GET /v1/cohorts/:id" do
      it "should render the cohort as json" do
        get "v1/cohorts/#{cohort.id}"
        expect(response.json).to eq serialize(cohort)
      end
    end

    describe "PUT /v1/cohorts/:id" do
      it "should render unauthorized" do
        put "v1/cohorts/#{cohort.id}", cohort: {name: "clown pajams"}
        expect(response.status).to eq 401
        expect(response.json).to eq("errors"=>["Unauthorized"], "status"=>401)
      end
    end


    describe "DELETE /v1/users/:id" do
      it "should render unauthorized" do
        delete "/v1/cohorts/#{cohort.id}"
        expect(response.status).to eq 401
        expect(response.json).to eq("errors"=>["Unauthorized"], "status"=>401)
      end
    end

  end



  as_an :editor do

    describe 'GET /v1/cohorts' do
      it "should render all cohorts as json" do
        get '/v1/cohorts'
        expect( response ).to be_ok
        expect( response.body ).to eq dbc.cohorts.all.to_json
      end
    end

    describe 'POST /v1/cohorts' do
      it "should render unauthorized" do
        post '/v1/cohorts', cohort: {name: "clown pajams"}
        expect(response.status).to eq 401
        expect(response.json).to eq("errors"=>["Unauthorized"], "status"=>401)
      end
    end


    describe "GET /v1/cohorts/:id" do
      it "should render the cohort as json" do
        get "v1/cohorts/#{cohort.id}"
        expect(response.json).to eq serialize(cohort)
      end
    end

    describe "PUT /v1/cohorts/:id" do
      it "should render unauthorized" do
        put "v1/cohorts/#{cohort.id}", cohort: {name: "clown pajams"}
        expect(response.status).to eq 401
        expect(response.json).to eq("errors"=>["Unauthorized"], "status"=>401)
      end
    end


    describe "DELETE /v1/users/:id" do
      it "should render unauthorized" do
        delete "/v1/cohorts/#{cohort.id}"
        expect(response.status).to eq 401
        expect(response.json).to eq("errors"=>["Unauthorized"], "status"=>401)
      end
    end

  end

end
