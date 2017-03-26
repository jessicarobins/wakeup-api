require 'descriptive_statistics'

class Station < ApplicationRecord
  has_many :transactions
  
  validates_uniqueness_of :route_name
  
  def find_last_bike_by_day
    transactions
      .group_by(&:day)
      .map do |key, value|
        Transaction.find_last_bike(value)
      end
      .compact
  end
  
  def statistics
    last_bike = find_last_bike_by_day
    
    if last_bike.count > 0
      stats = last_bike
        .map(&:time)
        .map{|t| t.change(:month => 1, :day => 1, :year => 2000)}
        .map(&:seconds_since_midnight)
        .descriptive_statistics
        
      return {
        median: format_time(stats[:median]),
        mean: format_time(stats[:mean]),
        standard_deviation: minutes(stats[:standard_deviation]),
        range: minutes(stats[:range]),
        q1: format_time(stats[:q1]),
        q3: format_time(stats[:q3]),
        min: format_time(stats[:min]),
        max: format_time(stats[:max])
      }
    end
    
    nil
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
    
    def format_time(t)
      Time.at(t).utc.strftime("%H:%M")
    end
    
    def minutes(t)
      (t/60).round
    end
end
