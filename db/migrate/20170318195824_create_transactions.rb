class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.integer :station_id
      t.datetime :time
      
      t.timestamps
    end
  end
end
