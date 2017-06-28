class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :from_id
      t.string :from_name
      t.string :from_email
      t.string :from_phone
      t.string :message
      t.integer :to_id
      t.string :to_email

      t.timestamps null: false
    end
  end
end
