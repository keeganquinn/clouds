class DeviseUpdateUsers < ActiveRecord::Migration
  def change
    add_column :users, :reset_password_sent_at, :datetime

    remove_column :users, :remember_token
  end
end
