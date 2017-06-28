class CreateAgentProfiles < ActiveRecord::Migration
  def change
    create_table :agent_profiles do |t|
      t.integer :user_id
      t.string  :license
      t.string  :specialties, nil:false, default:{}
      
      t.integer :lifetime_views

      t.string  :slug #for urls
      
      t.timestamps null: false
    end
  end
end
