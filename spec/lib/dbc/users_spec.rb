require 'spec_helper'

describe Dbc::Users do

  let!(:user){ create('dbc/user') }
  let(:serializer){ Dbc::User::Serializer.new(dbc) }
  let(:user_as_json){ Dbc::User::Serializer.new(dbc).call user }

  def serialize user
    serializer.serialize user
  end

  describe "all" do
    it "should return all the users as json" do
      expect(dbc.users.all).to eq Dbc::User.all.map(&serializer)
    end
  end

  describe "create" do
    it "should create a new user and return it as json" do
      attributes = attributes_for('dbc/user')
      expect{ dbc.users.create(attributes) }.to change{ Dbc::User.count }.by(1)
    end
  end

  describe "show" do
    it "should return all the users as json" do
      expect(dbc.users.show(user.id)).to eq serialize(user)
    end
  end

  describe "update" do
    it "should find, update and return the user as json" do
      user_attributes = dbc.users.update(user.id, name: "Paul Sutera")
      expected_user_attributes = serialize(user)
      expected_user_attributes["name"] = "Paul Sutera"
      expected_user_attributes["updated_at"] = user_attributes["updated_at"]
      expect(user_attributes).to eq expected_user_attributes
    end
  end

  describe "destroy" do
    it "should return all the users as json" do
      expect(dbc.users.destroy(user.id)).to eq serialize(user)
    end
  end

end
