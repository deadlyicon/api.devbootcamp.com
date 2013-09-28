class FixtureBuilder

  include FactoryGirl::Syntax::Methods

  def self.build(&block)
    new.instance_eval(&block)
  end

end
