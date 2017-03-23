class AddQ3pt2Data < ActiveRecord::Migration[5.0]
  def change
    file_name = "#{Rails.root}/public/2016q3pt2.csv"
    
    Transaction.import(:file => file_name)
  end
end
