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
        new(value).find_last_bike
      end
      .compact
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
      last_bike = collection.last
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