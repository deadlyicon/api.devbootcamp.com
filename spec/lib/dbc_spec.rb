require 'spec_helper'

describe Dbc do

  let(:current_users){ [create('dbc/user'), create('dbc/user')] }

  let(:dbc){ Dbc.new as: current_users.map(&:id) }


  describe "#current_users" do
    it "should return an instance of Dbc::Users" do
      expect(dbc.current_users).to eq current_users
    end
  end

  describe "#users" do
    it "should return an instance of Dbc::Users" do
      expect(dbc.users).to be_a Dbc::Users
    end
  end

end
