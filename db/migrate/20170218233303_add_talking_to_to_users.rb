class AddTalkingToToUsers < ActiveRecord::Migration
  def change
    add_column :users, :talking_to, :integer
  end
end
