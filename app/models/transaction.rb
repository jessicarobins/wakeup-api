class Transaction < ApplicationRecord
  belongs_to :transaction_type
  belongs_to :station
  
  scope :for_station, ->(station_id) { where(:start_station_id => station_id) }
  scope :for_day, ->(day) { where("time BETWEEN ? AND ?", day.beginning_of_day, day.end_of_day)}
  
  scope :by_station, -> { order(:station_id) }
  scope :by_time, -> { order(:time) }
  
  START_DATE = "Start date"
  END_DATE = "End date"
  START_STATION = "Start station number"
  END_STATION = "End station number"
  BIKE_NUMBER = "Bike number"
  
   def self.import(file:)
     
    ActiveRecord::Base.transaction do
      csv_text = File.read(file)
      csv = CSV.parse(csv_text, :headers => true)
      
      start_trans_id = TransactionType.find_by!(:name => "leave_station").id
      end_trans_id = TransactionType.find_by!(:name => "arrive_station").id
      
      csv.each do |row|
        data = row.to_hash
        
        start_station = Station.find_by!(
          :short_name => data[START_STATION])
        
        end_station = Station.find_by!(
          :short_name => data[END_STATION])
        
        start_transaction = Transaction.create!(
          :transaction_type_id => start_trans_id,
          :station_id => start_station.id,
          :time => format_time(:datetime => data[START_DATE]),
          :bike_number => data[BIKE_NUMBER]
        )
        
        end_transaction = Transaction.create!(
          :transaction_type_id => end_trans_id,
          :station_id => end_station.id,
          :time => format_time(:datetime => data[END_DATE]),
          :bike_number => data[BIKE_NUMBER]
        )
        
        Trip.create!(
          :start_id => start_transaction.id,
          :end_id => end_transaction.id
        )
      end
    end
  end
  
  private
    def self.format_time(datetime:)
      DateTime.strptime(datetime, "%m/%d/%Y %k:%M")
    end
end
