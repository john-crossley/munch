class Orders < ActiveRecord::Migration
  def change

    create_table :orders do |t|

      t.belongs_to :users
      t.string :choice

      t.timestamps

    end

  end

end
