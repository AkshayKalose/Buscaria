class CreateTeachables < ActiveRecord::Migration
  def change
    create_table :teachables do |t|
      t.belongs_to :user
      t.belongs_to :language
      t.integer :level
      
      t.timestamps null: false
    end
  end
end
