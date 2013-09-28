require 'spec_helper'

describe Dbc::User do

  it { should belong_to :cohort }

  it { should have_and_belong_to_many :user_groups }

  it { should have_many :challenge_attempts }

end
