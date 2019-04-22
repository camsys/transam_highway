class AddInspectorRole < ActiveRecord::DataMigration
  def up
    Role.create!({name: 'inspector', show_in_user_mgmt: true, privilege: false, weight: 5})
  end

  def down
    Role.destroy!(name: 'inspector')
  end
end