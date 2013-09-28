module DbcHelpers

  def current_user_ids
    []
  end

  def stub_current_user_ids current_user_ids=current_user_ids
    @dbc = Dbc.new as: current_user_ids
    ApplicationController.any_instance.stub(:current_user_ids).and_return(current_user_ids)
  end

  attr_reader :dbc

end
