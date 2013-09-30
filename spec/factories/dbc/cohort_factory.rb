factory 'dbc/cohort' do

  sequence(:name) {|i| "cohort #{i}"}
  slug            {|cohort| cohort.name.gsub(/\s+/,'_') }
  location_id     { Dbc::Location.first!.id }
  email           {|cohort| "#{cohort.slug}@example.com"}
  visible         true
  start_date      { Date.today.beginning_of_week }
  created_at      {|cohort| cohort.start_date - 6.weeks }
  updated_at      {|cohort| cohort.created_at }

end
