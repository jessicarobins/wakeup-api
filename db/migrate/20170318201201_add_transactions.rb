class AddTransactions < ActiveRecord::Migration[5.0]
  def change
    
    file_name = "#{Rails.root}/public/cabi1.csv"
    
    Transaction.import(:file => file_name)
  end
end
