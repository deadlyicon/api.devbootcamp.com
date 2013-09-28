factory 'dbc/user' do

  ignore do
    admin   false
    student false
    editor  false
  end

  sequence(:name)       {|i| "user #{i}"}
  email                 {|user| "#{user.name.gsub(/\s+/,'_')}@example.com"}
  password              { 'password' }
  password_confirmation { 'password' }
  roles                 { [] }

  after :build do |user, evaluator|
    user.roles += ['admin'] if evaluator.admin
    user.roles += ['student'] if evaluator.student
    user.roles += ['editor'] if evaluator.editor
  end

end
