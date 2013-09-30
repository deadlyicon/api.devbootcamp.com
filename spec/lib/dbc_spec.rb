require 'spec_helper'

describe Dbc do

  let(:admin){ Dbc::User.admin.first! }
  let(:student){ Dbc::User.student.first! }
  let(:editor){ Dbc::User.editor.first! }

  describe "authenticate_via_email_and_password" do
    context "when the email and password are good" do
      let(:user){ Dbc::User.first! }
      it "should return a Dbc instance for that single user" do
        dbc = Dbc.authenticate_via_email_and_password(user.email, 'password')
        expect(dbc).to be_a Dbc
        expect(dbc.user_group.users).to eq [user]
      end
    end
    context "when the email and password are bad" do
      it "should return nil" do
        expect( Dbc.authenticate_via_email_and_password('a','b') ).to be_nil
      end
    end
  end

  describe "authenticate_via_access_token" do
    context "when the access token is good" do
      let(:user_group){ Dbc::UserGroup.first! }
      it "should return a Dbc instance for that user group" do
        dbc = Dbc.authenticate_via_access_token(user_group.access_token)
        expect(dbc).to be_a Dbc
        expect(dbc.user_group).to eq user_group
      end
    end
    context "when the access token is bad" do
      it "should return nil" do
        expect( Dbc.authenticate_via_email_and_password('a','b') ).to be_nil
      end
    end
  end

  describe "as" do
    it "should take >=1 users or user_ids and create a user group from them" do
      Dbc::UserGroup.delete_all

      dbc = nil

      expect{ dbc = Dbc.as(admin)             }.to change{ Dbc::UserGroup.count }.by(1)
      expect(dbc.user_group.users).to eq [admin]

      expect{ dbc = Dbc.as(admin.id)          }.to change{ Dbc::UserGroup.count }.by(0)
      expect(dbc.user_group.users).to eq [admin]

      expect{ dbc = Dbc.as(admin, student)    }.to change{ Dbc::UserGroup.count }.by(1)
      expect(dbc.user_group.users).to eq [admin, student]

      expect{ dbc = Dbc.as(admin.id, student) }.to change{ Dbc::UserGroup.count }.by(0)
      expect(dbc.user_group.users).to eq [admin, student]
    end
  end

  describe '#roles' do
    it "should return the sum of the roles in the current user group" do
      expect(Dbc.as(admin                 ).roles).to eq ['admin']
      expect(Dbc.as(admin, student        ).roles).to eq ['admin', 'student']
      expect(Dbc.as(admin, student, editor).roles).to eq ['admin', 'student', 'editor']
    end
  end

  let(:dbc){ Dbc.as(admin) }

  describe "#user_group" do
    it "should return an instance of Dbc::UserGroup" do
      expect(dbc.user_group).to be_a Dbc::UserGroup
    end
  end

  describe "#users" do
    it "should return an instance of Dbc::Users" do
      expect(dbc.users).to be_a Dbc::Users
    end
  end

end
