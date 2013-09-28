if defined? ActiveRecord::FixtureBuilder
  ActiveRecord::FixtureBuilder.configure do |c|
    c.fixtures_path = Rails.root + 'spec/fixtures'
    c.builders_path = Rails.root + 'spec/fixture_builders'
  end
end
