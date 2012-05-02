class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      # Database authenticatable
      t.string :email, limit: 255, null: false, default: ''
      t.string :encrypted_password, limit: 128, null: false, default: ''

      # Recoverable
      t.string :reset_password_token, limit: 255
      # reset_password_sent_at added in later migration

      # Rememberable
      t.datetime :remember_created_at

      # Trackable
      t.integer :sign_in_count, default: 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip, limit: 255
      t.string :last_sign_in_ip, limit: 255

      # Confirmable
      t.string :confirmation_token, limit: 255
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at

      # Token authenticatable
      t.string :authentication_token, limit: 255

      t.timestamps
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
  end
end
