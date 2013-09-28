require 'factory_girl'

Dir[Rails.root+'spec/factories/*.rb'].each do |factory|
  require factory
end
