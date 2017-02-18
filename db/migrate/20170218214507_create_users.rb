class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.bigint :id_fb, null: false
      t.string :name_first
      t.string :name_last
      t.string :email
      t.integer :points, null: false, default: 0
      t.float :latitude
      t.float :longitude
      
      t.timestamps null: false
      
      t.index :id_fb, unique: true
    end
  end
end
