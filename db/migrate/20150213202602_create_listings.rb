class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      
      t.string  :type #["apartment","house","land","commercial","farm","warehouse","office"]

      t.integer :listing_type #["sale","rent"]

      t.boolean :featured

      t.text    :description
      t.string  :property_url

      t.integer :step, default: 0

      t.integer :location_id
      t.integer :agent_id

      t.integer :status_id, null: false, default: 0

      t.decimal :list_price
      t.date    :list_date

      t.integer :primary_photo_id
      t.boolean :hide_address
      t.boolean :sold, :default => false

      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end
  end
end
