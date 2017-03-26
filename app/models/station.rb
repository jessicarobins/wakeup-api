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
  
  def route_from_name
    # split on the / because we don't want that. use the
    # first part of the name because why not
    s = name.split("\/").first
    # we don't want & either so replace that with.. something
    # maybe the word 'and'
    s.gsub!(/&/, 'and')
    # remove all spaces and replace with.. nothing? or -?
    s.gsub!(/ /, '')
    #downcase, for good measure
    s.downcase!
    
    s
  end
  
end
