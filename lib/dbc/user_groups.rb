class Dbc::UserGroups < Dbc::Resource

  undef_method :all,:create, :update, :destroy

end
