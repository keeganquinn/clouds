class AddUserAttributes < ActiveRecord::Migration
  def change
    add_column :users, :login, :string, :limit => 64
    add_column :users, :name, :string, :limit => 128
    add_column :users, :city, :string, :limit => 128
    add_column :users, :country, :string, :limit => 2
    add_column :users, :content, :text
  end
end
