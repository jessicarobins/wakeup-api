require 'descriptive_statistics'

class Station < ApplicationRecord
  has_many :transactions
  
  validates_uniqueness_of :route_name
  
  def find_last_bike_by_day
    TransactionsCollection.new(transactions).find_last_bike_by_day
  end
  
  def statistics
    TransactionsCollection.new(transactions).statistics
  end
  
  def route_from_name
    # split on the / because we don't want that. use the
    # first part of the name because why not
    name_parts = name.split("\/")
    s = name_parts.first
    # we don't want & either so replace that with.. something
    # maybe the word 'and'
    
    s = parse_name s
    
    # if it doesn't exist already
    if !Station.find_by(:route_name => s)
      return s
    end
    
    s = name_parts.last
    s = parse_name s
    s
  end
  
  
  private
    def parse_name(s)
      s.gsub!(/&/, 'and')
      # remove all spaces and replace with.. nothing? or -?
      s.gsub!(/ /, '')
      #downcase, for good measure
      s.downcase!
      
      s
    end
end
