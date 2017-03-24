require 'descriptive_statistics'

class Station < ApplicationRecord
  has_many :transactions
  
  def find_last_bike_by_day
    transactions
      .group_by(&:day)
      .map do |key, value|
        Transaction.find_last_bike(value)
      end
      
  end
  
  def median_last_bike
    day_array = find_last_bike_by_day
      .map(&:only_time)
      .median
      .try(:round)
  end
  
end
