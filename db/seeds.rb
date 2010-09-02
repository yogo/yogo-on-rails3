# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

begin

  print "Creating System Roles..."

  user_role = SystemRole.create(:name => 'User', :description => 'Default user in the system',
                                :actions => ["project$retrieve"])
  user_role.move(:to => 1)

  project_manager_role = SystemRole.create(:name => 'Project Manager', :description => 'Able to create projects',
                                     :actions => ["project$retrieve", "project$update", "role$retrieve", "user$retrieve", "role$retrieve"])
  project_manager_role.move(:to => 2)

  sys_admin = SystemRole.first_or_new(:name => 'Administrator', :description => 'System role for Administrators',
                                      :actions => SystemRole.available_permissions)
  sys_admin.move(:to => 3)

  print "Done\n"

  print "Creating Users..."

  User.create(:login => 'yogo', :email => "yogo@montana.edu", :first_name => "System", :last_name => "Administrator", :password => 'change me', :password_confirmation => 'change me', :system_role => sys_admin)
  
  print "Done\n"
  
  print "Creating Roles..."
  pi = Role.create(:name => "Principal Investigator", :description => "Principal Investigators create projects to pursue research goals.", :actions => ((Role.available_permissions - Role.to_permissions) + ['role$retrieve'] - ['project$destroy']))
  pi.move(:to => 1)
  
  print "Done\n"
end