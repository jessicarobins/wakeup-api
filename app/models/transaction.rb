class Transaction < ApplicationRecord
  belongs_to :station
  
  scope :for_station, ->(station_id) { where(:start_station_id => station_id) }
  scope :for_day, ->(for_day) { where("time BETWEEN ? AND ?", for_day.beginning_of_day, for_day.end_of_day)}
  
  scope :by_station, -> { order(:station_id) }
  scope :by_time, -> { order(:time) }
  
  DATE = "Start_date"
  STATION = "Start_station_number"
  
  NINE_THIRTY_AM = 93000
  
  def self.import(file:)
     
    ActiveRecord::Base.transaction do
      csv_text = File.read(file)
      csv = CSV.parse(csv_text, :headers => true)
      
      csv.each do |row|
        data = row.to_hash
        
        station = Station.find_by!(
          :short_name => data[STATION])
        
        Transaction.create!(
          :station_id => station.id,
          :time => data[DATE].to_time
        )
        puts "transaction for #{data[DATE]} created"
      end
    end
  end
  
  def self.find_last_bike(collection)
    last_bike = collection.first
    max_difference = 0
    
    collection.each_cons(2) do |a,b|
      if (b.only_time-a.only_time > max_difference)
        last_bike = a
        max_difference = b.only_time-a.only_time
      end
    end
    
    if (NINE_THIRTY_AM - collection.last.only_time > max_difference)
      last_bike = collection.last
    end
    
    last_bike
  end
  
  def day
    time.beginning_of_day
  end
  
  def only_time
    time.utc.strftime("%H%M%S").to_i
  end
  
end
