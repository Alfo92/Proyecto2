class CreateSearchHistories < ActiveRecord::Migration
  def change
    create_table :search_histories do |t|
      t.integer :user_id
      t.text :searchs_for

      t.timestamps null: false
    end
  end
end
