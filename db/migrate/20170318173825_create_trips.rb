class CreateTrips < ActiveRecord::Migration[5.0]
  def change
    create_table :trips do |t|
      t.integer :start_id
      t.integer :end_id
      
      t.timestamps
    end
  end
end
