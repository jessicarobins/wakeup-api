class CreateStations < ActiveRecord::Migration[5.0]
  def change
    create_table :stations do |t|
      t.string :name
      t.integer :cabi_id
      t.string :short_name
      t.integer :region_id
      t.integer :capacity
      t.integer :latitude
      t.integer :longitude
      
      t.timestamps
    end
  end
end
