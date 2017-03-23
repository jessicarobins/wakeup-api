require 'descriptive_statistics'

class Station < ApplicationRecord
  has_many :transactions
  
  def find_last_bike_by_day
    transactions
      .group_by(&:day)
      .map do |key, value|
        Transaction.find_last_bike(value)
      end
      .map(&:time)
  end
  
  def median_last_bike
    day_array = find_last_bike_by_day.median.try(:round)
  end
  
end
