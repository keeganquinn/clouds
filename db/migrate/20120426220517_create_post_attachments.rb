class CreatePostAttachments < ActiveRecord::Migration
  def change
    create_table :post_attachments do |t|
      t.integer :post_id
      t.string :filename, :limit => 128
      t.string :content_type, :limit => 128
      t.binary :data, :limit => 1.gigabyte
      t.timestamps
    end
  end
end
