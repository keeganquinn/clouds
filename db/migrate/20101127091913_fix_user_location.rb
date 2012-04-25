class FixUserLocation < ActiveRecord::Migration
  def up
    remove_column :users, :country
    rename_column :users, :city, :location
  end

  def down
    add_column :users, :country, :string, :limit => 2
    rename_column :users, :location, :city
  end
end
