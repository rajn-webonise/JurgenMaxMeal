class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.float :price
      t.integer :rid

      t.timestamps null: false
    end
  end
end
