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
  end

end
