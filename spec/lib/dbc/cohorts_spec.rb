require 'spec_helper'

describe Dbc::Cohorts do

  subject(:cohorts){ dbc.cohorts }
  let(:cohort){ Dbc::Cohort.first! }

  def serialize cohort
    dbc.cohorts.serializer.serialize cohort
  end

  as_an :admin do

    describe "all" do
      it "should return all the cohorts as json" do
        expect( cohorts.all ).to eq Dbc::Cohort.all.map{|u| serialize u}
      end
    end

    describe "create" do
      it "should create a new cohort and return it as json" do
        attributes = attributes_for('dbc/cohort').slice(
          :name,
          :location,
          :in_session,
          :start_date,
          :email,
          :visible,
          :slug,
        ).stringify_keys

        cohort_json = nil
        expect{ cohort_json = cohorts.create(attributes.dup) }.to change{ Dbc::Cohort.count }.by(1)
        expect( cohort_json.slice(*attributes.keys) ).to eq attributes
      end
    end

    describe "show" do
      it "should return the given the cohort as json" do
        expect(dbc.cohorts.show(cohort.id)).to eq serialize(cohort)
      end
    end

    describe "update" do
      it "should find, update and return the cohort as json" do
        cohort_attributes = dbc.cohorts.update(cohort.id, name: "Spider Monkies")
        expected_cohort_attributes = serialize(cohort)
        expected_cohort_attributes["name"] = "Spider Monkies"
        expected_cohort_attributes["updated_at"] = cohort_attributes["updated_at"]
        expect(cohort_attributes).to eq expected_cohort_attributes
      end
    end

    describe "destroy" do
      it "should return all the cohorts as json" do
        expect(dbc.cohorts.destroy(cohort.id)).to eq serialize(cohort)
      end
    end

  end

  as_a :student do

    describe "all" do
      it "should return all the cohorts as json" do
        expect( cohorts.all ).to eq Dbc::Cohort.all.map{|u| serialize u}
      end
    end

    describe "create" do
      it "should raise a Dbc::PermissionsError" do
        attributes = attributes_for('dbc/cohort')
        expect{ cohorts.create(attributes) }.to raise_error(Dbc::PermissionsError)
      end
    end

    describe "show" do
      it "should return the given the cohort as json" do
        expect(dbc.cohorts.show(cohort.id)).to eq serialize(cohort)
      end
    end

    describe "update" do
      it "should find, update and return the cohort as json" do
        expect{ dbc.cohorts.update(cohort.id, name: "Spider Monkies") }.to raise_error(Dbc::PermissionsError)
      end
    end

    describe "destroy" do
      it "should return all the cohorts as json" do
        expect{ dbc.cohorts.destroy(cohort.id) }.to raise_error(Dbc::PermissionsError)
      end
    end

  end

  as_a :editor do

    describe "all" do
      it "should return all the cohorts as json" do
        expect( cohorts.all ).to eq Dbc::Cohort.all.map{|u| serialize u}
      end
    end

    describe "create" do
      it "should raise a Dbc::PermissionsError" do
        attributes = attributes_for('dbc/cohort')
        expect{ cohorts.create(attributes) }.to raise_error(Dbc::PermissionsError)
      end
    end

    describe "show" do
      it "should return the given the cohort as json" do
        expect(dbc.cohorts.show(cohort.id)).to eq serialize(cohort)
      end
    end

    describe "update" do
      it "should find, update and return the cohort as json" do
        expect{ dbc.cohorts.update(cohort.id, name: "Spider Monkies") }.to raise_error(Dbc::PermissionsError)
      end
    end

    describe "destroy" do
      it "should return all the cohorts as json" do
        expect{ dbc.cohorts.destroy(cohort.id) }.to raise_error(Dbc::PermissionsError)
      end
    end

  end

end
