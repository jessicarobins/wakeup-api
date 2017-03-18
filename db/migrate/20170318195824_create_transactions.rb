class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.integer :transaction_type_id
      t.integer :station_id
      t.datetime :time
      t.string :bike_number
      
      t.timestamps
    end
    
    add_index :transactions, [:bike_number, :time], unique: true
  end
end
