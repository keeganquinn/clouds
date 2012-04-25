class AddFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.integer :user_id
      t.integer :follow_user_id
      t.timestamps
    end

    add_index :follows, :user_id
    add_index :follows, :follow_user_id
    add_index :follows, [:user_id, :follow_user_id], unique: true
  end
end
