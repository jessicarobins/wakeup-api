class AttemptCreateTransactions < ActiveRecord::Migration[5.0]
  def change
    file_name = "#{Rails.root}/public/all.csv"
    
    Transaction.import(:file => file_name)
  end
end
