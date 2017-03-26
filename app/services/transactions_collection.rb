require 'descriptive_statistics'

class TransactionsCollection
  attr_reader :transactions
  
  NINE_THIRTY_AM = 93000
  DIFF_THRESHOLD = 1000 #10 min
  
  def initialize(transactions)
    @transactions = transactions
  end
  
  def find_last_bike_by_day
    transactions
      .group_by(&:day)
      .map do |key, value|
        TransactionsCollection.new(value).find_last_bike
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

  def find_last_bike
    last_bike = transactions.first
    max_difference = 0
    
    transactions.each_cons(2) do |a,b|
      if (b.only_time-a.only_time > max_difference)
        last_bike = a
        max_difference = b.only_time-a.only_time
      end
    end
    
    if (NINE_THIRTY_AM - transactions.last.only_time > max_difference)
      last_bike = transactions.last
      max_difference = NINE_THIRTY_AM - transactions.last.only_time
    end
    
    if (max_difference > DIFF_THRESHOLD)
      return last_bike
    end
    
    nil
  end
  
  private
    def format_time(t)
      Time.at(t).utc.strftime("%H:%M")
    end
    
    def minutes(t)
      (t/60).round
    end
end