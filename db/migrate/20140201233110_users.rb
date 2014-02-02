class Users < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.string :username
      t.string :mobile

      t.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, :mobile, unique: true
  end
end
