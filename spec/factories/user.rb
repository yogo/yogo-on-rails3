# Defining a user factory

Factory.define(:user) do |u|
  u.sequence(:login) {|n| "yogo_#{n}"}
  u.sequence(:first_name) {|n| "firstname#{n}"}
  u.sequence(:last_name) {|n| "lastname#{n}"}
  u.association :system_role, :factory => :system_role
  u.email {|a| "#{a.first_name}.#{a.last_name}@example.com"}
  u.password 'a_password'
  u.password_confirmation {|a| a.password }

end