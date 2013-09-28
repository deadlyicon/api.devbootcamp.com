require 'spec_helper'

describe Users do

  let!(:user){ create(:user) }

  describe "index" do
    it "should return all the users as json" do
      expect(Users.index).to eq [user].as_json
    end
  end

  describe "create" do
    it "should create a new user and return it as json" do
      attributes = attributes_for(:user)
      expect{ Users.create(attributes) }.to change{ User.count }.by(1)
    end
  end

  describe "new" do
    it "should return a new user as json" do
      expect(Users.new).to eq User.new.as_json
    end
  end

  describe "show" do
    it "should return all the users as json" do
      expect(Users.show(user.id)).to eq user.as_json
    end
  end

  describe "update" do
    it "should find, update and return the user as json" do
      user_attributes = Users.update(user.id, name: "Paul Sutera")
      expected_user_attributes = user.as_json
      expected_user_attributes["name"] = "Paul Sutera"
      expected_user_attributes["updated_at"] = user_attributes["updated_at"]
      expect(user_attributes).to eq expected_user_attributes
    end
  end

  describe "destroy" do
    it "should return all the users as json" do
      expect(Users.destroy(user.id)).to eq user.as_json
    end

  end

end
