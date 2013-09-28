require 'spec_helper'

describe Dbc do

  let(:current_users){ Dbc::User.first(3) }

  let(:dbc){ Dbc.new as: current_users.map(&:id) }


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
