class Station < ApplicationRecord
  has_many :transactions
  
  def find_last_bike_by_day
    transactions
      .group_by(&:day)
      .map do |key, value|
        Transaction.find_last_bike(value)
      end
      .map(&:only_time)
  end
  
end
