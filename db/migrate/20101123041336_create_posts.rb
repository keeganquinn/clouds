class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.integer :in_reply_to_post_id
      t.string :code, limit: 256
      t.string :subject, limit: 256
      t.text :body
      t.boolean :published
      t.timestamps
    end
  end
end
