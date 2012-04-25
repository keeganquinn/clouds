class GenerateUsernames < ActiveRecord::Migration
  def up
    users = User.find_all_by_username(nil)

    users.each do |user|
      user.username = "user#{user.id}"
      user.save(validate: false)
    end
  end

  def down
  end
end
