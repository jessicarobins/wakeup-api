class CreateTransactionTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :transaction_types do |t|
      t.string :name
      t.timestamps
    end
    
    TransactionType.create!(:name => 'leave_station')
    TransactionType.create!(:name => 'arrive_station')
  end
end
