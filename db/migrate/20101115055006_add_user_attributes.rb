class AddUserAttributes < ActiveRecord::Migration
  def self.up
    add_column :users, :login, :string, :limit => 64
    add_column :users, :name, :string, :limit => 128
    add_column :users, :city, :string, :limit => 128
    add_column :users, :country, :string, :limit => 2
    add_column :users, :content, :text
  end

  def self.down
    remove_column :users, :login
    remove_column :users, :name
    remove_column :users, :city
    remove_column :users, :country
    remove_column :users, :content
  end
end
