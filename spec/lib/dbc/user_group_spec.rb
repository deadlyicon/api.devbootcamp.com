require 'spec_helper'

describe Dbc::UserGroup do

  let(:users){ Dbc::User.first(3) }

  describe "for" do
    it "should find or create a record for the given users" do
      user_group = Dbc::UserGroup.for(users)
      expect(user_group.users).to eq users
      expect(Dbc::UserGroup.for(users)).to eq user_group

      users.each do |user|
        expect(user.user_groups).to include user_group
      end
    end

    it "it should create uniq user groups" do
      user1, user2, user3, user4 = Dbc::User.first(4)

      group1 = Dbc::UserGroup.for [user1,user2,user3]
      group2 = Dbc::UserGroup.for [user2,user3,user4]

      expect(group1).to_not eq group2

      expect(group1.users).to eq [user1,user2,user3]
      expect(group2.users).to eq [user2,user3,user4]
    end

    it "should return nil when the user ids are invalid" do
      expect{ Dbc::UserGroup.for([])        }.to raise_error(Dbc::UserGroup::Invalid, 'a user group must have at least 1 user')
      expect{ Dbc::UserGroup.for([9999999]) }.to raise_error(Dbc::UserGroup::Invalid, 'Couldn\'t find Dbc::User with id=9999999')
    end
  end

end
