class CreateViews < ActiveRecord::Migration
  def change
    create_table :views do |t|
      t.string :viewable_type
      t.integer :viewable_id
      t.string :ip_address

      t.timestamps null: false
    end
  end
end
