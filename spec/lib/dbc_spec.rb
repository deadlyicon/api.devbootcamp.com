require 'spec_helper'

describe Dbc do

  let(:admin){ Dbc::User.admin.first! }
  let(:student){ Dbc::User.student.first! }
  let(:editor){ Dbc::User.editor.first! }

  describe "as" do
    it "should take >=1 users or user_ids and create a user group from them" do
      Dbc::UserGroup.delete_all

      dbc = nil

      expect{ dbc = Dbc.as(admin)             }.to change{ Dbc::UserGroup.count }.by(1)
      expect(dbc.current_user_group.users).to eq [admin]

      expect{ dbc = Dbc.as(admin.id)          }.to change{ Dbc::UserGroup.count }.by(0)
      expect(dbc.current_user_group.users).to eq [admin]

      expect{ dbc = Dbc.as(admin, student)    }.to change{ Dbc::UserGroup.count }.by(1)
      expect(dbc.current_user_group.users).to eq [admin, student]

      expect{ dbc = Dbc.as(admin.id, student) }.to change{ Dbc::UserGroup.count }.by(0)
      expect(dbc.current_user_group.users).to eq [admin, student]
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

  describe "#current_user_group" do
    it "should return an instance of Dbc::UserGroup" do
      expect(dbc.current_user_group).to be_a Dbc::UserGroup
    end
  end

  describe "#users" do
    it "should return an instance of Dbc::Users" do
      expect(dbc.users).to be_a Dbc::Users
    end
  end

end
