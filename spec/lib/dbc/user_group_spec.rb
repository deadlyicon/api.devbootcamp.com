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

    it "description" do
      user1, user2, user3, user4 = Dbc::User.first(4)

      group1 = Dbc::UserGroup.for [user1,user2,user3]
      group2 = Dbc::UserGroup.for [user2,user3,user3]

      expect(group1).to_not eq group2

      # binding.pry

    end
  end

end
