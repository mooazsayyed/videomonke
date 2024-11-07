class AddUserIdToPosts < ActiveRecord::Migration[7.1]
  def change
    add_reference :posts, :user, foreign_key: true, null: true
  end
end