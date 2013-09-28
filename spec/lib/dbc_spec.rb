require 'spec_helper'

describe Dbc do

  before{ become :admin }

  describe "#current_user_group" do
    it "should return an instance of Dbc::Users" do
      expect(dbc.current_user_group.users).to eq current_users
    end
  end

  describe "#users" do
    it "should return an instance of Dbc::Users" do
      expect(dbc.users).to be_a Dbc::Users
    end
  end

end
